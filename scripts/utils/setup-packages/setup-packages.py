import subprocess
from dataclasses import dataclass
from pathlib import Path
from textwrap import dedent
from time import sleep
from typing import Literal

from pick import pick

# If you add here, you must add to class Package
available_pkgmgrs = ["brew", "apt", "dnf"]


@dataclass
class DistroPackage:
    name: str | None = None
    repository: str | None = (
        None  # Expects ALL prefixes and postfixes (e.g.: ppa, https, /formulae, etc)
    )
    brew_cask: bool = False
    replace_pkgmgr_command: str | None = None


@dataclass
class Package:
    name: str
    # If you add new distro here, you must add to PkgManager alias
    brew: DistroPackage | Literal[False] | None = None
    apt: DistroPackage | Literal[False] | None = None
    dnf: DistroPackage | Literal[False] | None = None
    config: str | None = None
    what_is: str | None = None
    post_install_commands: str | None = None


packages: list[Package] = [
    Package(name="neovim", config="nvim"),
    Package(name="efm-langserver", what_is="EFM Language server (USED WITH NEOVIM)"),
    Package(name="bspwm", brew=False, config="bspwm"),
    Package(name="sxhkd", brew=False, config="sxhkd"),
    Package(
        name="yabai",
        brew=DistroPackage(repository="FelixKratz/formulae"),
        apt=False,
        dnf=False,
        config="yabai",
    ),
    Package(
        name="borders",
        brew=DistroPackage(repository="FelixKratz/formulae"),
        apt=False,
        dnf=False,
        config="yabai",
    ),
    Package(
        name="skhd",
        brew=DistroPackage(repository="FelixKratz/formulae"),
        apt=False,
        dnf=False,
        config="skhd",
    ),
    Package(
        name="brightnessctl",
        brew=False,
        post_install_commands="""
            sudo chown root:root /usr/bin/brightnessctl
            sudo chmod 4775 /usr/bin/brightnessctl
        """,
    ),
    Package(name="redshift", brew=False),
    Package(name="curl", brew=False),
    Package(name="the_silver_searcher", apt=DistroPackage(name="silversearcher-ag")),
    Package(name="tree"),
    Package(
        name="flatpak",
        brew=False,
        apt=False,
        what_is="snap-like package manager for RH distributions",
    ),
    Package(name="feh", brew=False, what_is="Image viewer"),
    Package(
        name="imagemagick",
        brew=False,
        dnf=DistroPackage(name="ImageMagick"),
        what_is="CLI image manipulation",
    ),
    Package(
        name="procps",
        brew=False,
        what_is="Process management",
    ),
    Package(name="alsa-utils", brew=False, what_is="Sound management"),
    Package(name="acpi", brew=False, what_is="Power management"),
    Package(name="dunst", brew=False, what_is="Notification daemon replacement"),
    Package(name="scrot", brew=False, what_is="Screenshot utility"),
    Package(name="alacritty", brew=DistroPackage(brew_cask=True)),
    Package(
        name="signal",
        brew=DistroPackage(brew_cask=True),
        apt=DistroPackage(
            replace_pkgmgr_command="""
                    sudo apt-get install software-properties-common apt-transport-https curl -y
                    curl -fSsL https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg
                    echo deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main | sudo tee /etc/apt/sources.list.d/signal-messenger.list
                    sudo apt-get update
                    sudo apt-get install signal-desktop -y
                """
        ),
        dnf=DistroPackage(
            replace_pkgmgr_command="""
                    sudo flatpak install flathub org.signal.Signal
                """
        ),
    ),
    Package(
        name="spotify",
        brew=DistroPackage(brew_cask=True),
        apt=DistroPackage(
            replace_pkgmgr_command="""
                    sudo apt-get install curl libcanberra-gtk-module software-properties-common apt-transport-https -y
                    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/spotify.gpg > /dev/null
                    echo "deb [signed-by=/usr/share/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
                    sudo apt-get update
                    sudo apt-get install spotify-client -y
                """
        ),
        dnf=DistroPackage(
            replace_pkgmgr_command="""
                    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                    sudo flatpak install flathub com.spotify.Client
                """
        ),
    ),
]


def select_packages(packages: list[Package], pkg_manager: str) -> list[Package]:
    title = "Choose packages to install. Toggle with [space]. Confirm selection with [enter]."

    # Filter ONLY packages with the pkg_manager option
    available_packages = [p for p in packages if getattr(p, pkg_manager) != False]
    # Format option names
    options = [
        f"{p.name
            if not getattr(p, pkg_manager) or not getattr(p, pkg_manager).name
            else getattr(p, pkg_manager).name
        }{"" if not p.what_is else f" - {p.what_is}"}"
        for p in available_packages
    ]
    selected = pick(options, title, multiselect=True)
    indices = [index for (_, index) in selected]

    if len(available_packages) != len(options):
        raise Exception(
            "Something went wrong: available_packages and options name list have different sizes."
        )

    return [available_packages[i] for i in indices]


def generate_install_script(
    packages: list[Package], selected_packages: list[Package], pkg_manager: str
):
    standard_install: list[str] = []
    cask_install: list[str] = []
    replace_install: list[str] = []
    post_install: list[str] = []
    repository_add: set[str] = set()
    lookup_fail: list[str] = []

    for pkg in selected_packages:
        # Regardless of installation method, handle post-install commands
        if pkg.post_install_commands:
            post_install.append(pkg.post_install_commands)

        # Handle packages with special commands
        pkg_manager_settings = getattr(pkg, pkg_manager)
        if pkg_manager_settings and pkg_manager_settings.replace_pkgmgr_command:
            replace_install.append(pkg_manager_settings.replace_pkgmgr_command)
            continue

        # Handle taps/repositories
        if pkg_manager_settings and pkg_manager_settings.repository:
            repository_add.add(pkg_manager_settings.repository)

        # Fetch name per package manager
        pkgname = (
            pkg.name
            if not pkg_manager_settings or not getattr(pkg_manager_settings, "name")
            else getattr(pkg_manager_settings, "name")
        )

        # Handle brew casks
        if pkg_manager_settings and pkg_manager_settings.brew_cask:
            cask_install.append(pkgname)
            continue

        # Handle standard packages
        standard_install.append(pkgname)

    output = ""

    match pkg_manager:
        case "apt":
            for r in repository_add:
                output += f"""
                sudo add-apt-repository {r}
                """
            output += f"""
                sudo apt-get update
                sudo apt-get install {" ".join(standard_install)} -y
            """
        case "dnf":
            for r in repository_add:
                output += f"""
                sudo dnf config-manager --add-repo {r}
                """
            output += f"""
                sudo dnf update
                sudo dnf install {" ".join(standard_install)} -y
            """
        case "brew":
            output += f"""
                brew tap {" ".join(repository_add)}
                brew install {" ".join(standard_install)}
            """
        case _:
            raise Exception(f"Pkg manager {pkg_manager} not found")
    output = dedent(output)

    if cask_install:
        if pkg_manager != "brew":
            raise Exception(
                f"Pkg manager {pkg_manager} should not have cask distributions to install"
            )

        output += dedent(
            f"""
            brew install --cask {" ".join(cask_install)}
        """
        )

    if replace_install:
        for cmd in replace_install:
            output += dedent(cmd)

    if post_install:
        for cmd in post_install:
            output += dedent(cmd)

    # Generate errors
    if lookup_fail:
        output += f"""
            echo "Failed to install packages: {lookup_fail}
        """

    return dedent(output)


def symlink_configs(
    selected_packages: list[Package], src_config: Path, dest_config: Path
) -> str:
    output = ""
    for pkg in selected_packages:
        if pkg.config:
            output += f"""
                rm -f {dest_config}/{pkg.config} && ln -s {src_config}/{pkg.config} {dest_config}/{pkg.config}
            """

    return dedent(output)


if __name__ == "__main__":
    import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Auto-installer for packages. Includes symlinking of config files"
    )
    # CHECK Maybe makes more sense to check within the script
    parser.add_argument(
        "package_manager",
        metavar="package_manager",
        type=str,
        help="Package manager to use (e.g., apt, dnf, brew)",
    )
    parser.add_argument(
        "-s",
        "--src-config",
        type=str,
        help="Source of .config files. Default is .dotfiles/.config",
    )
    parser.add_argument(
        "-d",
        "--dest-config",
        type=str,
        help="Destination of .config files. Default it $HOME/.config",
    )
    parser.add_argument(
        "-n", "--no-symlink", action="store_true", help="Skip symlink creation"
    )

    args = parser.parse_args()

    utils_path = Path(__file__).parent.parent
    pkg_manager = args.package_manager.lower()
    dotfiles_config_path = (
        Path(args.src_config)
        if args.src_config
        else utils_path.parent.parent / ".config"
    )
    user_config_path = (
        Path(args.dest_config) if args.dest_config else Path.home() / ".config"
    )
    skip_symlink = args.no_symlink

    if not Path.exists(dotfiles_config_path):
        raise Exception(f".config folder not found under {dotfiles_config_path}")

    if not Path.exists(user_config_path):
        raise Exception(f"User .config folder not found under {user_config_path}")

    if not pkg_manager in available_pkgmgrs:
        print(f"ERROR: Package manager '{pkg_manager}' not supported.")
        exit(1)

    script = "#!/bin/bash"
    selected = select_packages(packages, pkg_manager)
    script += generate_install_script(packages, selected, pkg_manager)

    if not skip_symlink:
        script += dedent(
            f"""
            mkdir -p {user_config_path}
        """
        )
        script += symlink_configs(selected, dotfiles_config_path, user_config_path)

    script = dedent(script)

    output_path = utils_path / "setup-tmp.sh"
    with open(output_path, "w") as f:
        f.write(script)

    print("Your terminal will be blank momentarily.")
    sleep(0.5)
    print("This is normal")
    sleep(0.5)
    print("Just wait...")
    sleep(0.5)
    print("")

    result = subprocess.run(["bash", output_path], capture_output=True, text=True)

    print("\n------------------\n\n", result.stdout)
    print("" if result.stderr else "\n------------------\n", result.stderr)

    # Supposedly interactive version
    # proc = subprocess.Popen(output_path, stdout=subprocess.PIPE, bufsize=1)
    # for line in iter(proc.stdout.readline, b""):
    #     print(line)
    # proc.stdout.close()
    # proc.wait()

    output_path.unlink()

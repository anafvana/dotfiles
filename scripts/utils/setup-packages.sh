UTILS="$SCRIPTS/utils"
os="$(uname)"

setup_linux() {
	pkg=$(bash "$UTILS/id_pkgmgr.sh")
	case $pkg in
	   apt)
		   sudo apt update
	       sudo apt install python3 python3-pip python3-venv
		   ;;
	   dnf)
		   sudo dnf update
		   sudo dnf install python3 python3-pip python3-venv
	       ;;
	   *)
	       echo "No setup for package manager: $pkg"
		   exit 1
	       ;;
	esac
}

case "$os" in
	Darwin)
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		brew install python
		python3 -m pip install virtualenv
		pkg="brew"
		;;
	Linux)
		setup_linux
		;;
	*)
		echo "No setup for OS: $os"
		exit 1
		;;
esac

echo `which python`
cd "$UTILS/setup-packages"
unalias venv
if [ ! -d "$(pwd)/venv" ]; then python3 -m venv "$(pwd)/venv"; fi; source "$(pwd)/venv/bin/activate"
python -m pip install -r requirements.txt
chmod +x setup-packages.py
tmpScript=$(python "./setup-packages.py" "$pkg")
cd "$SCRIPTS"
chmod +x tmpScript
echo "In bash $tmpScript"

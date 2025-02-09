UTILS="$SCRIPTS/utils"
os="$(uname)"

setup_linux() {
	pkg=$(bash "$UTILS/id_pkgmgr.sh")
	case $pkg in
	   apt)
	       #bash "$UTILS/setup-apt.sh"
	       echo "apt"
		   ;;
	   dnf)
	       bash "$UTILS/setup-dnf.sh"
	       ;;
	   *)
	       echo "No setup for package manager: $pkg"
	       ;;
	esac
}

case "$os" in
	Darwin)
		bash "$UTILS/setup-mac.sh"
		;;
	Linux)
		setup_linux
		;;
	*)
		echo "No setup for OS: $os"
esac

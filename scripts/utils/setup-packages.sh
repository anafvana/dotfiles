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

echo ""
sleep 1
echo "YOU MUST RUN THE FOLLOWING COMMAND TO CONTINUE WITH THE INSTALLATION:"
sleep 1
echo "cd \"$UTILS/setup-packages\""
echo "if [ ! -d "$(pwd)/venv" ]; then python3 -m venv "$(pwd)/venv"; fi"
echo "source \"$(pwd)/venv/bin/activate\""
echo "python -m pip install -r requirements.txt"
echo "python ./setup-packages.py $pkg; deactivate; rm -r venv; cd - >> /dev/null"

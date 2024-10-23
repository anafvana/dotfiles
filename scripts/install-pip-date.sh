#! /bin/bash

pip install pip-date

pipDir="$(dirname `which pip`)"

packages=(pip-search pip-describe pyfileinfo pyOSinfo pip-date pipbyday)

for p in ${packages[@]}
do
	pkgPath="$pipDir/$p.py"
	echo "Handling $pkgPath"
	echo "Changing permissions"
	chmod 744 $pkgPath
	if ! alias "$p" &>/dev/null && ! grep -q "alias $p=" ~/.bashrc; then
		echo "Creating alias"
		echo "alias $p='$pkgPath'" >> ~/.bashrc
	fi
done

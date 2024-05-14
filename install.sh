#!/bin/bash
set -e

echo '-- Automatically installing system dependencies...'

cd "$(dirname $0)"
# --version > /dev/null 2> /dev/null && SUDO=|| SUDO=

get_linux_distro() {
	if grep -Eq "Ubuntu" /etc/*-release 2>/dev/null; then
		echo "Ubuntu"
	elif grep -Eq "Deepin" /etc/*-release 2>/dev/null; then
		echo "Deepin"
	elif grep -Eq "Raspbian" /etc/*-release 2>/dev/null; then
		echo "Raspbian"
	elif grep -Eq "uos" /etc/*-release 2>/dev/null; then
		echo "UOS"
	elif grep -Eq "LinuxMint" /etc/*-release 2>/dev/null; then
		echo "LinuxMint"
	elif grep -Eq "elementary" /etc/*-release 2>/dev/null; then
		echo "elementaryOS"
	elif grep -Eq "Debian" /etc/*-release 2>/dev/null; then
		echo "Debian"
	elif grep -Eq "Kali" /etc/*-release 2>/dev/null; then
		echo "Kali"
	elif grep -Eq "Parrot" /etc/*-release 2>/dev/null; then
		echo "Parrot"
	elif grep -Eq "CentOS" /etc/*-release 2>/dev/null; then
		echo "CentOS"
	elif grep -Eq "fedora" /etc/*-release 2>/dev/null; then
		echo "fedora"
	elif grep -Eq "openSUSE" /etc/*-release 2>/dev/null; then
		echo "openSUSE"
	elif grep -Eq "Arch Linux" /etc/*-release 2>/dev/null; then
		echo "ArchLinux"
	elif grep -Eq "ManjaroLinux" /etc/*-release 2>/dev/null; then
		echo "ManjaroLinux"
	elif grep -Eq "Gentoo" /etc/*-release 2>/dev/null; then
		echo "Gentoo"
	elif grep -Eq "alpine" /etc/*-release 2>/dev/null; then
		echo "Alpine"
	elif [ "x$(uname -s)" == "xDarwin" ]; then
		echo "MacOS"
	else
		echo "Unknown"
	fi
}

detect_platform() {
	local platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

	# check for MUSL
	if [ "${platform}" = "linux" ]; then
		if ldd /bin/sh | grep -i musl >/dev/null; then
			platform=linux_musl
		fi
	fi

	# mingw is Git-Bash
	if echo "${platform}" | grep -i mingw >/dev/null; then
		platform=win
	fi

	echo "${platform}"
}

detect_arch() {
	local arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

	if echo "${arch}" | grep -i arm >/dev/null; then
		# ARM is fine
		echo "${arch}"
	else
		if [ "${arch}" = "i386" ]; then
			arch=x86
		elif [ "${arch}" = "x86_64" ]; then
			arch=x64
		elif [ "${arch}" = "aarch64" ]; then
			arch=arm64
		fi

		# `uname -m` in some cases mis-reports 32-bit OS as 64-bit, so double check
		if [ "${arch}" = "x64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
			arch=x86
		fi

		echo "${arch}"
	fi
}
install_pacman() {
	pacman -S --noconfirm ripgrep || true
	pacman -S --noconfirm fzf || true
	pacman -S --noconfirm cmake
	pacman -S --noconfirm make
	pacman -S --noconfirm git
	pacman -S --noconfirm curl
	pacman -S --noconfirm unzip
}

install_apt() {
	export DEBIAN_FRONTEND=noninteractive
	apt update
	apt install -y ripgrep || true
	apt install -y fzf || true
	apt install -y cmake
	apt install -y git
	apt install -y curl
    apt install -y unzip
}

install_yum() {
	yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
	yum install -y ripgrep || true
	yum install -y fzf || true
	yum install -y cmake
	yum install -y make
	yum install -y git
	yum install -y curl
}

install_brew() {
	brew install ripgrep || true
	brew install fzf || true
	brew install cmake
	brew install git
	brew install curl
    brew install unzip
}

install_dnf() {
	dnf install -y ripgrep || true
	dnf install -y fzf || true
	dnf install -y cmake
	dnf install -y git
	dnf install -y curl
    dnf install -y unzip
}

install_zypper() {
	zypper in --no-confirm ripgrep || true
	zypper in --no-confirm fzf || true
	zypper in --no-confirm cmake
	zypper in --no-confirm git
	zypper in --no-confirm curl
    zypper in --no-confirm unzip
}

do_install() {
	distro=$(get_linux_distro)
	echo "-- Linux distro detected: $distro"

	if [ $distro == "Ubuntu" ]; then
		install_apt
	elif [ $distro == "Deepin" ]; then
		install_apt
	elif [ $distro == "Debian" ]; then
		install_apt
	elif [ $distro == "Kali" ]; then
		install_apt
	elif [ $distro == "Raspbian" ]; then
		install_apt
	elif [ $distro == "ArchLinux" ]; then
		install_pacman
	elif [ $distro == "ManjaroLinux" ]; then
		install_pacman
	elif [ $distro == "MacOS" ]; then
		install_brew
	elif [ $distro == "fedora" ]; then
		install_dnf
	elif [ $distro == "openSUSE" ]; then
		install_zypper
	elif [ $distro == "CentOS" ]; then
		install_yum
	else
		# TODO: add more Linux distros here..
		echo "-- WARNING: Unsupported Linux distro: $distro"
		echo "-- The script will not install any dependent packages like clangd."
		echo "-- You will have to manually install clangd, if you plan to make a working C++ IDE."
		exit 1
	fi

	echo "-- System dependency installation complete!"
}

do_install

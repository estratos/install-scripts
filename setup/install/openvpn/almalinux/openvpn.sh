#!/bin/bash
#
#
#
exiterr()  { echo "Error: $1" >&2; exit 1; }
exiterr2() { exiterr "'apt-get install' fallo."; }
exiterr3() { exiterr "'yum install' fallo."; }
exiterr4() { exiterr "'zypper install' fallo."; }

check_os() {
	
   if [[ -e /etc/almalinux-release || -e /etc/rocky-release || -e /etc/centos-release ]]; then
		os="centos"
		os_version=$(grep -shoE '[0-9]+' /etc/almalinux-release /etc/rocky-release /etc/centos-release | head -1)
		group_name="nobody"
  else
		exiterr "This installer seems to be running on an unsupported distribution.
Supported distros are Ubuntu"
	fi
}
check_os_ver() {
  if [[ "$os" == "centos" && "$os_version" -lt 8 ]]; then
		if ! grep -qs "Amazon Linux release 2 " /etc/system-release; then
			exiterr "CentOS 8 or higher is required to use this installer.
This version of CentOS is too old and unsupported."
		fi
 }
 install_pkgs() {
 if [[ "$os" = "centos" ]]; then
		if grep -qs "Amazon Linux release 2 " /etc/system-release; then
			(
				set -x
				amazon-linux-extras install epel -y >/dev/null
			) || exit 1
		else
			(
				set -x
				yum -y -q install epel-release >/dev/null
			) || exiterr3
		fi
		(
			set -x
			yum -y -q install openvpn openssl ca-certificates tar $firewall >/dev/null 2>&1
		) || exiterr3

 }
 
check_os
check_os_ver
install_pkgs

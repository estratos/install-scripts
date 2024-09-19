#!/bin/bash
exiterr()  { echo "Error: $1" >&2; exit 1; }
exiterr2() { exiterr "'apt-get install' fallo."; }
exiterr3() { exiterr "'yum install' fallo."; }
exiterr4() { exiterr "'zypper install' fallo."; }
check_os() {
	if grep -qs "ubuntu" /etc/os-release; then
		os="ubuntu"
		os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
		group_name="nogroup"
  else
		exiterr "This installer seems to be running on an unsupported distribution.
Supported distros are Ubuntu"
	fi
}
check_os_ver() {
	if [[ "$os" == "ubuntu" && "$os_version" -lt 2004 ]]; then
		exiterr "Ubuntu 20.04 or higher is required to use this installer.
This version of Ubuntu is too old and unsupported."
	fi
 }
insta_ubuntu_2004() { 
        if [[ "$os" == "ubuntu" && "$os_version" == 2004 ]]; then
        wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -
        echo "deb http://as-repository.openvpn.net/as/debian focal main">/etc/apt/sources.list.d/openvpn-as-repo.list
        
	else
                exiterr "this line sets 22.04 repos."
        fi

}
 
check_os
check_os_ver

apt -y update
apt -y upgrade
apt -y install ca-certificates wget net-tools gnupg
insta_ubuntu_2004
apt -y update
apt -y install openvpn-as

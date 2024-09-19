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
                echo "Release: " 
		echo $os_version
                
  else
		exiterr "This installer seems to be running on an unsupported distribution.
Supported distros are Ubuntu 20.04 & 22.04"
	fi
}
check_os_ver() {
	if [[ "$os" == "ubuntu" && "$os_version" -lt 2004 ]]; then
		exiterr "Ubuntu 20.04 or higher is required to use this installer.This version of Ubuntu is too old and unsupported."
         else
	 if [[ "$os" == "ubuntu" && "$os_version" == "2404" ]]; then
	 exiterr "Ubuntu 24.04 is not yet supported."
	 fi
	 
	 
	fi
 }
insta_ubuntu_2004_2204() { 
        if [[ "$os" == "ubuntu" && "$os_version" == "2004" ]]; then
        wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -
        echo "deb http://as-repository.openvpn.net/as/debian focal main">/etc/apt/sources.list.d/openvpn-as-repo.list
        apt -y update
        apt -y install openvpn-as
      
        
	else
         mkdir -p /etc/apt/keyrings # directory does not exist on older releases
         curl -fsSL https://swupdate.openvpn.net/repos/repo-public.gpg | gpg --dearmor > /etc/apt/keyrings/openvpn-repo-public.gpg
        # Always get the latest package for 22.04, even Beta versions
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/openvpn-repo-public.gpg] http://build.openvpn.net/debian/openvpn/testing jammy main" > /etc/apt/sources.list.d/openvpn-aptrepo.list
        apt-get update && apt-get install openvpn
	apt-get install openvpn-dco-dkms
                
        fi

}
 
check_os
check_os_ver

apt -y update
apt -y upgrade
apt -y install ca-certificates wget net-tools gnupg
insta_ubuntu_2004_2204


#!/bin/bash
export LC_ALL=C
export LANG=C
export LANGUAGE=en_US.UTF-8

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  sudoCmd="sudo"
else
  sudoCmd=""
fi

# copied from v2ray official script
# colour code
RED="31m"      # Error message
GREEN="32m"    # Success message
YELLOW="33m"   # Warning message
BLUE="36m"     # Info message
# colour function
colorEcho(){
  echo -e "\033[${1}${@:2}\033[0m" 1>& 2
}

#copied & modified from atrandys trojan scripts
#copy from Qiushui Yibing ss scripts
if [[ -f /etc/redhat-release ]]; then
  release="centos"
  systemPackage="yum"
  #colorEcho ${RED} "unsupported OS"
  #exit 0
elif cat /etc/issue | grep -Eqi "debian"; then
  release="debian"
  systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
  release="ubuntu"
  systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
  release="centos"
  systemPackage="yum"
  #colorEcho ${RED} "unsupported OS"
  #exit 0
elif cat /proc/version | grep -Eqi "debian"; then
  release="debian"
  systemPackage="apt-get"
elif cat /proc/version | grep -Eqi "ubuntu"; then
  release="ubuntu"
  systemPackage="apt-get"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
  release="centos"
  systemPackage="yum"
  #colorEcho ${RED} "unsupported OS"
  #exit 0
fi

# a trick to redisplay menu option
show_menu() {
  echo "1) Installation acceleration"
  echo "2) Set up swap"
  echo "3) Uninstall Alibaba Cloud Shield"
  echo "4) Performance Test (LemonBench)"
  echo "5) Performance test (Oldking)"
}

continue_prompt() {
  read -p "Continue other operations (yes/no)? " choice
  case "${choice}" in
    y|Y|[yY][eE][sS] ) show_menu ;;
    * ) exit 0;;
  esac
}

netSpeed() {
  ${sudoCmd} ${systemPackage} install curl -y -qq
  wget -q -N https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh -O /tmp/tcp.sh && chmod +x /tmp/tcp.sh && ${sudoCmd} /tmp/tcp.sh
}

setSwap() {
  ${sudoCmd} ${systemPackage} install curl -y -qq
  curl -sL https://raw.githubusercontent.com/phlinhng/v2ray-tcp-tls-web/master/tools/set_swap.sh | bash
}

rmAliyundun() {
  ${sudoCmd} ${systemPackage} install curl -y -qq
  curl -sL https://raw.githubusercontent.com/phlinhng/v2ray-tcp-tls-web/master/tools/rm_aliyundun.sh | bash
}

# credit: https://github.com/LemonBench/LemonBench
LemonBench() {
  ${sudoCmd} ${systemPackage} install curl -y -qq
  curl -sL https://raw.githubusercontent.com/LemonBench/LemonBench/master/LemonBench.sh | bash -s -- --mode fast
}

# credit: https://www.oldking.net/350.html
Oldking() {
  ${sudoCmd} ${systemPackage} install wget -y -qq
  wget -qO- https://git.io/Jvh0J | ${sudoCmd} bash
}

menu() {
  cd "$(dirname "$0")"
  colorEcho ${YELLOW} "VPS Toolkit by phlinhng"
  echo ""

  PS3="Select operation [Enter any value or press Ctrl+C to exit]: "
  COLUMNS=39
  options=("Installation Acceleration" "Setup Swap" "Uninstall Alibaba Cloud Shield" "Performance Test (LemonBench)" "Performance Test (Oldking)")
  select opt in "${options[@]}"
  do
    case "${opt}" in
      "Installation acceleration") netSpeed && continue_prompt ;;
      "Set up swap") setSwap && continue_prompt ;;
      "Uninstall Alibaba Cloud Shield") rmAliyundun && continue_prompt ;;
      "Performance Test (LemonBench)") LemonBench && exit 0 ;;
      "Performance test (Oldking)") Oldking && exit 0 ;;
      *) break;;
    esac
  done

}

menu

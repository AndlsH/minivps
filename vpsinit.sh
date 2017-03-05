#!/usr/bin/bash

#############################################################
#
#               One Click VPS initializer
#
#       Author:   Andls
#       Version:  0.0.1
#       Date:     2017.03.04
#       Homepage: https://www.andls.com/
#       GitHub:   https://github.com/AndlsH/vpsinit
#
#############################################################

Welcome()
{
    clear
    echo
    echo "#####################################"
    echo "#     One Click VPS initializer     #"
    echo "#                                   #"
    echo "#             By Andls              #"
    echo "#       https://www.andls.com/      #"
    echo "#####################################"
    echo
{
    yum install nodejs npm --enablerepo=epel
    git clone git://github.com/c9/core.git --depth=1 /opt/c9sdk
    bash /opt/c9sdk/scripts/install-sdk.sh
    npm install pm2 -g
    pm2 start /opt/c9sdk/server.js -n c9sdk -x -- -w ~ -p 8080 -l 0.0.0.0 -a admin:qweasd
    pm2 startup
}

}
# Set root password
SetRootPwd()
{
    echo "Please input password for root:"
    read -p "(Default password: qwer1234):" rootPwd
    [ -z "${rootPwd}" ] && rootPwd="qwer1234"
    echo
    echo "---------------------------"
    echo "  root password = ${rootPwd}"
    echo "---------------------------"
    echo
    # set
    echo ${rootPwd} | passwd --stdin root
}

SetSshPort()
{
    echo "Please input SSH port:"
    read -p "(Default port: 2048):" sshPort
    [ -z "${sshPort}" ] && sshPort="2048"
    echo
    echo "---------------------------"
    echo "  SSH port = ${sshPort}"
    echo "---------------------------"
    echo
    sed -i "/Port 22/aPort ${sshPort}" /etc/ssh/sshd_config
    systemctl restart sshd
}
# Disable selinux
DisableSelinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

action=$1
[ -z $1 ] && action=Welcome
${action}

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
ChkSys()
{
    osMachine=`uname -m`
}

# TODO
# kernel selector
# appen exclutions
ChangeKernel()
{
    cp /etc/yum.conf /etc/yum.conf.bak
    cat >> /etc/yum.conf <<- EOF
exclude=kernel-2* kernel-3* kernel-4*
EOF
    wget http://vault.centos.org/7.1.1503/updates/x86_64/Packages/kernel-3.10.0-229.1.2.el7.x86_64.rpm
    rpm -ivh kernel-3.10.0-229.1.2.el7.x86_64.rpm --force

}

SetFirewalld()
{
    [[ ! -z ${port} ]] && systemctl status firewalld > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        firewall-cmd --permanent --zone=public --add-port=${port}/tcp
        firewall-cmd --permanent --zone=public --add-port=${port}/udp
        firewall-cmd --reload
    else
        echo "Firewalld is not running, trying to start..."
        systemctl start firewalld
        if [ $? -eq 0 ]; then
            firewall-cmd --permanent --zone=public --add-port=${port}/tcp
            firewall-cmd --permanent --zone=public --add-port=${port}/udp
            firewall-cmd --reload
        else
            echo "WARNING: Try to start firewalld failed. Please configure port ${port} manually."
        fi
    fi
}

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
case "${action}" in
    Welcome)
        ${action}
        ;;
    *)
        echo "I cannot understand ${action}!"
        echo "Please double check your input!"
        echo "Use `usage` argument to see help!"
        ;;
esac


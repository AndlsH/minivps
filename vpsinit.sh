#!/usr/bin/bash

Welcome()
{
    clear
}
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
action=$1
[ -z $1 ] && action=Welcome
${action}

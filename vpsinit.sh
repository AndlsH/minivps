#!/usr/bin/bash

Welcome()
{
    clear
C9sdk()
{
    yum install nodejs npm --enablerepo=epel
    git clone git://github.com/c9/core.git --depth=1 /opt/c9sdk
    bash /opt/c9sdk/scripts/install-sdk.sh
    npm install pm2 -g
    pm2 start /opt/c9sdk/server.js -n c9sdk -x -- -w ~ -p 8080 -l 0.0.0.0 -a admin:qweasd
    pm2 startup
}

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

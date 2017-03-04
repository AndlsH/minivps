#!/usr/bin/bash

Welcome()
{
    clear
}
action=$1
[ -z $1 ] && action=Welcome
${action}

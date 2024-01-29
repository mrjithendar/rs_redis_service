#!bin/bash 

ORGANIZATION=DecodeDevOps
COMPONENT=redis
CONFIGFILE=/etc/$COMPONENT.conf

OS=$(hostnamectl | grep 'Operating System' | tr ':', ' ' | awk '{print $3$NF}')
selinux=$(sestatus | awk '{print $NF}')

if [ $OS == "CentOS8" ]; then
    echo -e "\e[1;33mRunning on CentOS 8\e[0m"
    else
        echo -e "\e[1;33mOS Check not satisfied, Please user CentOS 8\e[0m"
        exit 1
fi

if [ $selinux == "disabled" ]; then
    echo -e "\e[1;33mSE Linux Disabled\e[0m"
    else
        echo -e "\e[1;33mOS Check not satisfied, Please disable SE linux\e[0m"
        exit 1
fi

if [ $(id -u) -ne 0 ]; then
  echo -e "\e[1;33mYou need to run this as root user\e[0m"
  exit 1
fi

hostname $COMPONENT

echo -e "\e[1;33minstalling $COMPONENT-server\e[0m"
yum install -y $COMPONENT epel-release yum-utils
echo -e "\e[1;33mInstalled version:: $(redis-server --version)\e[0m"
## Example: Redis server v=5.0.3 sha=00000000:0 malloc=jemalloc-5.1.0 bits=64 build=9529b692c0384fb7

echo -e "\e[1;33mupdated $COMPONENT config\e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/g' $CONFIGFILE

echo -e "\e[1;33mstarting $COMPONENT service\e[0m"
systemctl enable $COMPONENT
systemctl restart $COMPONENT

if [ $? -eq 0 ]; then
    echo -e "\e[1;33m$COMPONENT configured successfully\e[0m"
    systemctl status $COMPONENT
    else
        echo -e "\e[1;33mfailed to configure $COMPONENT\e[0m"
        exit 0
fi
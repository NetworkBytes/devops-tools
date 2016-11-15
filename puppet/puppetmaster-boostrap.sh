#!/bin/bash -v


echo " - Configure TimeZone"
timedatectl set-timezone Australia/Sydney
yum -y install ntp
ntpdate pool.ntp.org
systemctl restart ntpd
systemctl enable ntpd

echo " - Configuring Hostname"
hostnamectl set-hostname puppetmaster --static
hostname puppetmaster

echo " - Install Puppet"
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppetserver puppetdb
sed -ie 's/JAVA_ARGS="-Xms2g -Xmx2/JAVA_ARGS="-Xms1g -Xmx1/' /etc/sysconfig/puppetserver

echo " - Installing Gems"
gem install r10k hiera-eyaml

echo " - Installing Puppet Modules"
puppet module install puppetlabs-puppetdb
puppet module install zack-r10k

echo " - Starting Puppet"
systemctl start puppetserver
systemctl enable puppetserver

echo " - Initial Puppet run"
puppet agent -t



#rm -rf /etc/puppetlabs/puppet/ssl/*
#puppet cert list -a




curl https://raw.githubusercontent.com/NetworkBytes/devops-tools/master/puppet/puppetmaster.pp |puppet apply -v

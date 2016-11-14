#!/bin/bash -v


# Set TimeZone
timedatectl set-timezone Australia/Sydney
yum -y install ntp
ntpdate pool.ntp.org
systemctl restart ntpd
systemctl enable ntpd

# Hostname
hostnamectl set-hostname puppetmaster --static
hostname puppetmaster

# Install Puppet
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppetserver puppetdb
sed -ie 's/JAVA_ARGS="-Xms2g -Xmx2/JAVA_ARGS="-Xms1g -Xmx1/' /etc/sysconfig/puppetserver

# Install Gems
gem install r10k hiera-eyaml

puppet module install puppetlabs-puppetdb
puppet module install zack-r10k


#systemctl start puppetserver
#systemctl enable puppetserver

curl https://raw.githubusercontent.com/NetworkBytes/devops-tools/master/puppet/puppetmaster.pp |puppet apply -v

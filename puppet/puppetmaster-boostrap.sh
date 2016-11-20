#!/bin/bash -v

HOST_NAME=puppet.localdomain

echo " - Configure TimeZone"
timedatectl set-timezone Australia/Sydney
yum -y install ntp
ntpdate pool.ntp.org
systemctl restart ntpd
systemctl enable ntpd

echo " - Configuring Hostname"
hostnamectl set-hostname $HOST_NAME --static
echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
hostname $HOST_NAME
sed -ie "s/127.0.0.1   localhost/127.0.0.1 puppet $HOST_NAME localhost/" /etc/hosts



echo " - Install Puppet"
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppetserver
cat << EOF >> /etc/puppetlabs/puppet/puppet.conf
dns_alt_names = puppet,$HOST_NAME
autosign = true
#certname = puppet
#[agent]
#certname = puppet
EOF
export PATH=$PATH:/opt/puppetlabs/bin
sed -ie 's/JAVA_ARGS="-Xms2g -Xmx2g/JAVA_ARGS="-Xms700m -Xmx700m/' /etc/sysconfig/puppetserver

# Ruby-devel required by generate-puppetfile
yum -y install ruby ruby-devel

echo " - Installing Gems"
GEMS="r10k hiera-eyaml hiera-eyaml-kms deep_merge aws-sdk generate-puppetfile"
  /bin/gem install $GEMS
  /opt/puppetlabs/server/bin/puppetserver gem install $GEMS
  /opt/puppetlabs/puppet/bin/gem install $GEMS

echo " - Installing Puppet Modules"
puppet module install puppetlabs-puppetdb
puppet module install zack-r10k
puppet module install puppet-hiera


echo " - Starting Puppet"
systemctl start puppetserver
systemctl enable puppetserver

echo " - Initial Puppet run"
# kick off a run to generate certs etc...
puppet agent -t

# Configure basic puppet server
curl https://raw.githubusercontent.com/NetworkBytes/devops-tools/master/puppet/puppetmaster.pp |puppet apply -v

echo " - R10K run"
r10k deploy environment -v

echo " - Final Puppet run"
puppet agent -t
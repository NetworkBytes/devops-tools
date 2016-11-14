
node puppetmaster {
 
  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

  # Confgure r10k
  include ::r10k
}


class { '::r10k':
  sources => {
    'NetworkBytes' => {
      'remote'  => 'https://github.com/NetworkBytes/puppet-control.git',
      'basedir' => "${::settings::confdir}/environments",
      'prefix'  => true,
    }
  },
}

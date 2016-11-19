node default {

  # Configure puppetdb and its underlying database
  class { 'puppetdb': }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

  # Configure hiera.yaml
  class { '::hiera':
    backends => ['eyaml'],
    hierarchy => [
      '%{environment}/%{calling_class}',
      '%{environment}',
      'common',
    ],
    eyaml           => true,
    eyaml_extension => 'yaml',
    merge_behavior  => 'deeper'
  }

  #Configure R10K
  class { '::r10k':
    sources => {
      'NetworkBytes' => {
        'remote'  => 'https://github.com/NetworkBytes/puppet-control.git',
        'basedir' => "${::settings::codedir}/environments",
        'prefix'  => false,
      }
    }
  }

}

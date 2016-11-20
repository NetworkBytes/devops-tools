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
    backend_options => {
      'eyaml' => {
        'kms-key-id'     => '87d7d8c8-0c7b-41f0-b06d-51e7e4e73524',
        'kms-aws-region' => 'ap-southeast-2'
      }
    },
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

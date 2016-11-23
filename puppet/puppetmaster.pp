node default {

  # Configure puppetdb and its underlying database
  class { 'puppetdb': }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

  # Configure hiera.yaml
  class { '::hiera':
    backends => ['eyaml'],
    hierarchy => [
      'nodes/%{::trusted.certname}',
      'apps/%{::host.application}/%{::host.role}.%{::host.environment}.%{::host.site}',
      'apps/%{::host.application}/%{::host.role}.%{::host.environment}',
      'apps/%{::host.application}/%{::host.role}.%{::host.site}',
      'apps/%{::host.application}/%{::host.role}',
      'apps/%{::host.application}.%{::host.environment}.%{::host.site}',
      'apps/%{::host.application}.%{::host.environment}',
      'apps/%{::host.application}',

      'domain/%{::host.domain}',

      'kernel/%{::kernel}',

      'modules/%{calling_class_path}/%{hiera_file}',
      'modules/%{calling_class_path}',

      # CATCH ALL
      'global'
    ],
    eyaml           => true,
    eyaml_extension => 'yaml',
    #backend_options => {
    #  'eyaml' => {
    #    'kms-key-id'     => '87d7d8c8-0c7b-41f0-b06d-51e7e4e73524',
    #    'kms-aws-region' => 'ap-southeast-2'
    #  }
    #},
    merge_behavior  => 'deeper'
  }
  file {'/etc/eyaml': ensure => 'directory'}
  file {'/etc/eyaml/config.yaml': 
    ensure => 'present', 
    content => "---\nkms_key_id: '87d7d8c8-0c7b-41f0-b06d-51e7e4e73524'\nkms_aws_region: 'ap-southeast-2'\n"
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

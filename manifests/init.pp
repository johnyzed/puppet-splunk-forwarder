class splunk(

  $input_hash,
  $deployment_server,
  $source_file,
  $deployment_port = $splunk::params::deployment_port, 
  $receiving_port = $splunk::params::receiving_port,

) inherits splunk::params {
  
  $deployment_string = "${deployment_server}:${deployment_port}"

  # Validate hash
  if ( $input_hash ) {
    if !is_hash($input_hash){
      fail("${input_hash} is not a valid hash")
    }
  }
  $input_title = keys($input_hash)

      package{'UniversalForwarder':
        provider => $splunk::params::provider,
        source => "${source_file}",
        ensure => installed,
        install_options => $splunk::params::install_options,
        notify => [ File['inputs.conf'] ]
      }

      service{$splunk::params::service_name:
        ensure => "running",
        subscribe => [ File['inputs.conf']],
        require => $splunk::params::service_require,
      }

      file{"inputs.conf":
        path => $splunk::params::inputs_path,
        notify => Service[$splunk::params::service_name],
        require => Package['UniversalForwarder'],
        content => $operatingsystem ? {
          'windows' => regsubst(template('splunk/inputs.conf.erb'), '\n', "\r\n", 'EMG'),
          default => template('splunk/inputs.conf.erb'),
        },
      }


      if $operatingsystem != 'windows' {

        exec {"start_splunk":
          creates => $splunk::params::start_splunk_create,
          command => $splunk::params::start_splunk_cmd,
          timeout => 0,
        }

        exec {"set_boot":
          creates => "/etc/init.d/splunk",
          command => $splunk::params::set_boot_cmd,
          require => Exec['start_splunk'],
        }

        file {'/etc/init.d/splunk':
          ensure  => file,
          require => Exec['set_boot']
        }

      }

      exec{'deploy_client':
        command => $operatingsystem ? {
          'windows' => "\"${installdir}\\bin\\splunk.exe\" set deploy-poll ${deployment_server}:${receiving_port} -auth admin:changeme",
          default => "${installdir}bin/splunk set deploy-poll ${deployment_server}:${receiving_port} -auth admin:changeme"
          },
        cwd => $splunk::params::deploy_cwd,        
        path => $::path,
        require => Package['UniversalForwarder'],
        notify => Service[$splunk::params::service_name]
      }
}
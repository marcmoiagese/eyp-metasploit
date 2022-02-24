class metasploit(
                  $manage_service        = true,
                  $manage_docker_service = true,
                  $service_ensure        = 'running',
                  $service_enable        = true,
                  $basedir               = '/opt',
                  $dbpassword            = 'cmVmZXJlbmR1bSAxIGRvY3R1YnJlIC0gc2kK',
                ) inherits metasploit::params{

  class { '::metasploit::install': }
  -> class { '::metasploit::config': }
  ~> class { '::metasploit::service': }
  -> Class['::metasploit']

}

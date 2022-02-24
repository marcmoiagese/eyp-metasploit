class metasploit::service inherits metasploit {

  #
  validate_bool($metasploit::manage_docker_service)
  validate_bool($metasploit::manage_service)
  validate_bool($metasploit::service_enable)

  validate_re($metasploit::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${metasploit::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $metasploit::manage_docker_service)
  {
    if($metasploit::manage_service)
    {
      service { $metasploit::params::service_name:
        ensure => $metasploit::service_ensure,
        enable => $metasploit::service_enable,
      }
    }
  }
}

class metasploit::install inherits metasploit {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  class { 'postgresql':
		wal_level           => 'hot_standby',
		max_wal_senders     => '3',
		checkpoint_segments => '8',
		wal_keep_segments   => '8',
    notify              => Class['::metasploit::service'],
	}

  postgresql::hba_rule { 'local only':
    user     => 'metasploit',
    database => 'metasploit',
    address  => '127.0.0.1/32',
  }

  postgresql::role { 'metasploit':
    password => $metasploit::dbpassword,
  }

  postgresql::schema { 'metasploit':
    owner => 'metasploit',
  }

  exec { "metasploit mkdir -p ${metasploit::basedir}":
    command => "mkdir -p ${metasploit::basedir}",
    creates => $metasploit::basedir,
  }

  exec { 'metasploit which git':
    command => 'which git',
    unless  => 'which git',
  }

  exec { 'metasploit which bundle':
    command => 'which bundle',
    unless  => 'which bundle',
  }

  exec { 'clone metasploit':
    cwd => $metasploit::basedir,
    command => 'git clone https://github.com/rapid7/metasploit-framework',
    timeout => 0,
    creates => "${metasploit::basedir}/metasploit-framework",
    require => Exec[ [ 'metasploit which git', "metasploit mkdir -p ${metasploit::basedir}", 'metasploit which bundle' ] ],
  }

  file { "${metasploit::basedir}/metasploit-framework/database.yml":
    ensure    => present,
    owner     => 'root',
    group     => 'root',
    mode      => '0400',
    content   => template("${module_name}/database_yaml.erb"),
    require   => Exec['clone metasploit'],
  }

  exec { 'bundle install metasploit':
    command => 'bundle install',
    cwd     => "${metasploit::basedir}/metasploit-framework",
  }

}

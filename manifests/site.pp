node default {
}

node /apt/ {

  package { "apt-mirror":
    ensure => "installed"
  }

  file { "/var/www/":
    ensure => "directory",
    recurse => true,
    owner => "www-data",
    group => "www-data"
  }

  file { "/var/spool/apt-mirror/mirror/files.freeswitch.org":
    ensure => "directory",
    recurse => true,
    owner => "www-data",
    group => "www-data"
  }

  file { "/var/spool/apt-mirror/mirror/files.freeswitch.org/repo/deb/debian/conf":
    ensure => "directory",
    recurse => true,
    owner => "www-data",
    group => "www-data"
  } -> class { 'nginx': }

  file { "/var/spool/apt-mirror/mirror/files.freeswitch.org/repo/deb/debian/conf/distributions":
    content => template("reprepro/conf/distributions"),
    require => File["/var/spool/apt-mirror/mirror/files.freeswitch.org/repo/deb/debian/conf"],
    owner => "www-data",
    group => "www-data"
  }

  file { 'nginx site conf':
    path => "/etc/nginx/sites-available/packages",
    content => template("nginx/sites-available/packages"),
    require => Class['nginx']
  }
  
  file {'nginx site link':
    path => "/etc/nginx/sites-enabled/packages",
    ensure => link,
    target => "/etc/nginx/sites-available/packages",
    require => File['nginx site conf']
  }
  
  file { 'nginx extra conf':
    path => "/etc/nginx/conf.d/extra.conf",
    content => template("nginx/conf.d/extra.conf"),
    require => Class['nginx']
  }

  file { 'apt mirror':
    path => "/etc/apt/mirror.list",
    content => template("apt/mirror.list")
  }
  
  exec { 'nginx restart':
    command => "/etc/init.d/nginx restart",
    require => [ File['nginx site link'], File['nginx extra conf'] ]
  }
  package { "curl":
    ensure => installed
  }
  
  package { "vim":
    ensure => installed
  }

  host { 'freeswitch-packages':
    name => 'freeswitch-packages',
    ip => $ipaddress_eth1,
    ensure => present
  }
}


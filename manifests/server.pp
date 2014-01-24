class nfs::server (
    $exports = ['share1', 'share2'],
    $networkallowed = $::network_eth0,
    $netmaskallowed = $::netmask_eth0,
  ) { 
  define list_exports {
    $export = $name
    file { $export:
      ensure => directory,
      mode   => '0775',
      owner  => 'root',
    }
  }
  list_exports { $exports:; } -> File['/etc/exports']
  package { 'rpcbind':
    ensure => latest,
  }
  package { 'nfs-utils':
    ensure => latest,
  }
  file { '/etc/sysconfig/nfs':
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "0644",
    source  => "puppet:///modules/nfs/sysconfig-nfs",
    require => Package['nfs-utils']
  }
  
  file { '/etc/exports':
    content => template("nfs/exports.erb"),
  } ~> Service['nfs']

  service { "rpcbind":
    ensure => running,
    enable => true,
  }
  service { "nfs":
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/sysconfig/nfs'],
    require   => Service['rpcbind']
  }
}
 

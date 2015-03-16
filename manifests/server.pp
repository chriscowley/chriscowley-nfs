# == Class: nfs::server
#
# Installs and configures an NFS server
# Currently only for RHEL6 and derivatives
#
# === Parameters
#
# Document parameters here.
#
# [*exports*]
#   Array listing the exports to be created
#   The default is /srv/share


# === Variables
#
# [*$networkallowed*]
#   Which network to allow access to the NFS share.
#   Defaults to eth0 (from facter).
#
# [*$netmaskallowed*]
#   Netmask of the network to allow access. Defaults to eth0 (from facter).
#
# [*$rquota_port*]
#   Force RQuota to bind to a specific port
#
# [*$lockd_tcp_port*]
#   Force lockd to bind to a specific TCP port
#
# [*$lockd_udp_port*]
#   Force lockd to bind to a specific UDP port
#
# [*$mountd_port*]
#   Force mountd to bind to a specific port
#
# [*$statd_port*]
#   Force statd to bind to a specific port
#
# === Examples
#
#  class { 'nfs::server':
#    $exports => [
#      '/srv/photos',
#      '/srv/videos',
#    ],
#    $networkallowed = '10.0.0.0',
#    $netmaskallowed = '255.0.0.0',
#  }
#
# === Authors
#
# Chris Cowley <chris@chriscowley.me.uk>
#
# === Copyright
#
# Copyright 2014 Chris Cowley
#

class nfs::server (
  $service_name = $nfs::service_name,
  $exports = [ '/srv/share'],
  $networkallowed = $::network_eth0,
  $netmaskallowed = $::netmask_eth0,
  $rquota_port    = '875',
  $lockd_tcp_port = '32803',
  $lockd_udp_port = '32769',
  $mountd_port    = '892',
  $statd_port     = '662',
) {
  #  nfs::list_exports { $exports:; } -> File['/etc/exports']
  package { 'rpcbind':
    ensure => latest,
  }
  package { 'nfs-utils':
    ensure => latest,
  }
  file { '/etc/sysconfig/nfs':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
#    source  => 'puppet:///modules/nfs/sysconfig-nfs',
    content => template('nfs/sysconfig-nfs.erb'),
    require => Package['nfs-utils']
  }

  file { '/etc/exports':
    content => template('nfs/exports.erb'),
  } ~> Service[$nfs::server::service_name]

  service { 'rpcbind':
    ensure => running,
    enable => true,
  }
  service { $nfs::server::service_name:
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/sysconfig/nfs'],
    require   => Service['rpcbind']
  }
}

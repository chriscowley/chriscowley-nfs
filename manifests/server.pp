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
# === Examples
#
#  class { nfs:
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
    $exports = [ '/srv/share'],
    $networkallowed = $::network_eth0,
    $netmaskallowed = $::netmask_eth0,
  ) {
  list_exports { $exports:; } -> File['/etc/exports']
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
    source  => 'puppet:///modules/nfs/sysconfig-nfs',
    require => Package['nfs-utils']
  }

  file { '/etc/exports':
    content => template('nfs/exports.erb'),
  } ~> Service['nfs']

  service { 'rpcbind':
    ensure => running,
    enable => true,
  }
  service { 'nfs':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/sysconfig/nfs'],
    require   => Service['rpcbind']
  }
}

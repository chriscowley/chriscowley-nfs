# == Class: nfs
#
# Installs and Configures Logstash from packages.
# Currently only for RHEL6 and derivatives
#
# This module is only really here for completeness, it is not actually used.
# Instead, just call nfs::server directly.
#
# In the future there may be a partnering nfs::client module, but I have not
# got round to it yet (if ever).
#
# === Parameters
#
# Document parameters here.
#
# === Variables
#
# === Examples
#
#  class { nfs::
#
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
class nfs (
  $service_name = $nfs::server::params::service_name,
){
}

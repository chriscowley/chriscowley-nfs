class nfs::params {
  case $::operatingsystemmajrelease {
    7: {
      service_name = 'nfs-server'
    }
    default: {
      service_name = 'nfs'
    }
  }
}

class nfs::params {
  if $operatingsystemmajrelease == '7' {
    $service_name = 'nfs-server'
  }
  else {
    $service_name = 'nfs'
  }
}

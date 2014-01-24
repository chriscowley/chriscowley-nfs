define list_exports {
    $export = $name
    file { $export:
      ensure => directory,
      mode   => '0775',
      owner  => 'root',
    }
  }


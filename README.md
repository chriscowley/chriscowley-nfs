# NFS
Currently only support RHEL6 and derivatives (I test on CentOS). The plan is for everything to do with Logstash to be managed though this module. 

For now it only does an NFS server and the config options are relatively limited. This is kind of on purpose; there are plenty of all-singing-all-dancing NFS modules on the Forge, but I wanted to cover 90% of bases (ok, myself) simply. As such I have tried to make the default relatively sane and simple. This does not mean they are the best, but it works easily.

The simplest possiblity is:

```
class { 'nfs::server': }
```

This will create a single folder called `/srv/share` and export to whichever network eth0 is attached to.

You can create as many shares as you want, and control which network they all go to (currently only a single network is support).

```
class { 'nfs::server':
  $exports => [
    '/srv/photos',
    '/srv/videos',
    ],
  $networkallowed = '10.0.0.0',
  $netmaskallowed = '255.0.0.0',
}
```

License
-------
GPL3

Contact
-------
chris AT chriscowley DOT me DOT uk

Support
-------

Please log tickets on my [Gitlab](http://gitlab.chriscowley.me.uk/puppet/chriscowley-nfs/)
class mynode (
  $ensure  = $mynode::params::ensure,
  $message = $mynode::params::message,
) inherits mynode::params {
  include ::systemd
  archive { '/tmp/node-v6.9.1-linux-x64.tar.xz':
    ensure        => present,
    extract       => true,
    extract_path  => '/opt',
    source        => 'https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz',
    checksum      => 'd4eb161e4715e11bbef816a6c577974271e2bddae9cf008744627676ff00036a',
    checksum_type => 'sha256',
    creates       => '/opt/node-v6.9.1-linux-x64',
    cleanup       => true,
    notify        => Service['nodejs'],
  }
  group { 'nodejs':
    ensure => present,
  }
  user {'nodejs':
    ensure  => present,
    shell   => '/bin/bash',
    home    => '/srv/nodejs',
    groups  => ['users', 'nodejs',],
    require => Group['nodejs'],
  }
  file { '/srv/node':
    ensure  => directory,
    owner   => nodejs,
    group   => nodejs,
    mode    => '0744',
    require => User['nodejs'],
  }
  file { '/srv/node/server.js':
    ensure  => present,
    owner   => nodejs,
    group   => nodejs,
    mode    => '0744',
    content => template('mynode/server.js.erb'),
    notify  => Service['nodejs'],
  }
  file {'/etc/systemd/system/nodejs.service':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('mynode/node_basic_server.service.erb'),
  }
  file {'/etc/default/nodejs':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('mynode/node_basic_server_default.erb'),
  }~>
  Exec['systemctl-daemon-reload']
  service { 'nodejs':
    ensure => 'running',
  }

}

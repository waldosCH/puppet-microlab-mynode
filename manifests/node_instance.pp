define mynode::node_instance (
  $ensure = $mynode::ensure,
  $listen_port = undef,
  $message = 'default message',
) {
  $process_ensure = $ensure ? {
    'present' => 'running',
    'absent'  => 'stopped',
    default   => 'running',
  }
  file { "/srv/node/server_${name}.js":
    ensure  => $ensure,
    owner   => nodejs,
    group   => nodejs,
    mode    => '0744',
    content => template('mynode/server.js.erb'),
    notify  => Service["nodejs_${name}"],
  }
  file {"/etc/systemd/system/nodejs_${name}.service":
    ensure  => $ensure,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('mynode/node_basic_server.service.erb'),
  }
  file {"/etc/default/nodejs_${name}":
    ensure  => $ensure,
    owner   => root,
    group   => root,
    mode    => '0744',
    content => template('mynode/node_basic_server_default.erb'),
  }~>
    Exec['systemctl-daemon-reload']
  service { "nodejs_${name}":
    ensure => $process_ensure,
    require => Class['mynode::nodeserver'],
  }
}
class mynode::nodeserver (
  $ensure = $mynode::ensure,
) {
  $directory_ensure = $ensure ? {
    'present' => 'directory',
    'absent'  => 'absent',
    default   => 'directory',
  }

  archive { '/tmp/node-v6.9.1-linux-x64.tar.xz':
    ensure        => $ensure,
    extract       => true,
    extract_path  => '/opt',
    source        => 'https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz',
    checksum      => 'd4eb161e4715e11bbef816a6c577974271e2bddae9cf008744627676ff00036a',
    checksum_type => 'sha256',
    creates       => '/opt/node-v6.9.1-linux-x64',
    cleanup       => true,
  }
  group { 'nodejs':
    ensure => $ensure,
  }
  user {'nodejs':
    ensure  => $ensure,
    shell   => '/bin/bash',
    home    => '/srv/node',
    groups  => ['users', 'nodejs',],
    require => Group['nodejs'],
  }
  file { '/srv/node':
    ensure  => $directory_ensure,
    owner   => nodejs,
    group   => nodejs,
    mode    => '0744',
    require => User['nodejs'],
  }
}

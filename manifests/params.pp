class mynode::params {
  $ensure = 'present'
  $config_hash = {
    'helloWorld' => { ensure => 'present', listen_port => 8080, message => 'hello world from params'},
  }
}

class mynode (
  $ensure      = $mynode::params::ensure,
  $config_hash = $mynode::params::config_hash,

) inherits mynode::params {
  include ::systemd
  class {'mynode::nodeserver' :
    ensure => $ensure,
  }
  class {'mynode::config' :
    ensure => $ensure,
    config_hash => $config_hash,
  }
}
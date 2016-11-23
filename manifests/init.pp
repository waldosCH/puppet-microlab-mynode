class mynode (
  $ensure  = $mynode::params::ensure,
  $message = $mynode::params::message,
) inherits mynode::params {
  include ::systemd

}

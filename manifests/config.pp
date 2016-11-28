class mynode::config (
  $ensure = $mynode::ensure,
  $config_hash = $mynode::config_hash,
) {
  create_resources( mynode::node_instance, $config_hash)
}
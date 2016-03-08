# Class: dell_info
#
# api_key = the api key to use when quering dell
# extra_facts = list of additional facts to identify dell servers
class dell_info (
  $api_key     = undef,
  $force       = false,
  $extra_facts = [],
) {
  validate_string($api_key)
  validate_bool($force)
  validate_array($extra_facts)
  file {'/etc/dell_info.yaml':
    ensure  => present,
    content => template('dell_info/etc/dell_info.yaml.erb'),
  }
  file {'/var/cache/facts.d':
    ensure => directory,
  }
}

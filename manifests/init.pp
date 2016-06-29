# Class: dell_info
#
# api_key = the api key to use when quering dell
# extra_facts = list of additional facts to identify dell servers
class dell_info (
  Optional[String]  $apikey       = $::dell_info::params::apikey,
  Boolean           $force        = $::dell_info::params::force,
  Array             $extra_facts  = $::dell_info::params::extra_facts,
  String            $api_url      = $::dell_info::params::api_url,
  String            $cache_dir    = $::dell_info::params::cache_dir,
  Integer           $cache_ttl    = $::dell_info::params::cache_ttl,
) {

  file {'/etc/dell_info.yaml':
    content => template('dell_info/etc/dell_info.yaml.erb'),
  }
  file { $cache_dir:
    ensure => directory,
  }
}

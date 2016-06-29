class dell_info::params {
  $api_key = undef,
  $force = false,
  $extra_facts = [],
  $api_url = 'https://api.dell.com/support/v2/assetinfo/warranty/tags.json'
  $cache_dir = '/var/cache/facts.d'
  $cache_ttl = 604800
}

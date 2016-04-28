require 'yaml'
require 'json'
require 'date'
require 'time'
require 'net/http'

conf_file = '/etc/dell_info.yaml'
config = Hash.new

#  URL used to query Dell's API
url = 'https://api.dell.com/support/v2/assetinfo/warranty/tags.json?apikey=%s&svctags=%s'

#  There are only three API keys at this time I think.  
apikey = '1adecee8a60444738f280aad1cd87d0e'
dell_machine = false

if  Facter.value('manufacturer') =~ /dell/i then
  dell_machine = true
end

if File.exists?(conf_file) then
  config = YAML.load_file(conf_file)
  if config['api_key'] then
    apikey = config['api_key']
  end
  if config['force'] then
    dell_machine = true
  end
  if config['extra_facts'].any? then
    config['extra_facts'].each do |fact|
      if Facter.value(fact) =~ /dell/i then
        dell_machine = true
      end
    end
  end
end

#  Where to store cache files.  This needs to change for windows.
cache_dir = "/var/cache/facts.d"

#  Name of cache file.  For now, unique file per serial number.
cache_file = "#{cache_dir}/#{Facter.value('serialnumber')}.json"

# Cache TTL = 1 week, in seconds.
cache_ttl = 604800 


dell_cache = nil
response = nil
cache_time = Time.at(0)

if Facter.value('manufacturer')
  if Facter.value('serialnumber') && dell_machine &&
    Facter.value('kernel') == 'Linux'

    # Use cache file if it exists.
    if File::exists?(cache_file)
      begin
        File.open(cache_file, "r") do |f|
          dell_cache = JSON.load(f)
        end
        cache_time = File.mtime(cache_file)
      rescue Exception => e
        cache_time = Time.at(0)
        Facter.debug("#{e.backtrace[0]}: #{$!}.")
      end
    else
      Facter.debug("Cache file not found.")
    end

    #  If no cache file, or cache file is expired, query Dell.
    if !dell_cache || (Time.now - cache_time) > cache_ttl
      url = url % [apikey, Facter.value('serialnumber')]
      begin
        Timeout::timeout(30) {
          Facter.debug('Getting api.dell.com')
          uri = URI(url)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)
        }
    
        begin
          if defined?(response)
            dell_cache = JSON.parse(response.body)
            Dir.mkdir(cache_dir) unless File::exists?(cache_dir)
            File.open(cache_file, "w") do |out|
              out.write(JSON.pretty_generate(dell_cache))
            end
          end
        rescue Exception => e
          Facter.debug("#{e.backtrace[0]}: #{$!}.")
        end
      rescue Exception => e
        Facter.debug("#{e.backtrace[0]}: #{$!}.")
      end
    else
      Facter.debug("Using cached data")
    end

    if defined?(dell_cache)
      begin
        pd = dell_cache['GetAssetWarrantyResponse']['GetAssetWarrantyResult']['Response']['DellAsset']['ShipDate']
        purchase_date = Date.parse(pd)
        Facter.add(:purchase_date) do
          setcode do
            purchase_date.to_s
          end
        end

        age = ((Date.today - purchase_date).to_i / 365.0)
        Facter.add(:server_age) do
          setcode do
            "%.2f years" % [age]
          end
        end

        warranties = dell_cache['GetAssetWarrantyResponse']['GetAssetWarrantyResult']['Response']['DellAsset']['Warranties']['Warranty']
        warranties = [warranties] unless warranties.is_a? Array
        covered = false

        warranties.each_with_index do |warranty,index|
          enddate = Date.parse(warranty['EndDate'])
          covered = (enddate > Date.parse(Time.now.to_s)) if covered == false
          Facter.add("warranty#{index}_expires") do
            setcode do
              enddate.to_s
            end
          end

          Facter.add("warranty#{index}_type") do
            setcode do
              warranty['EntitlementType']
            end
          end

          Facter.add("warranty#{index}_desc") do
            setcode do
              warranty['ServiceLevelDescription']
            end
          end
        end

        Facter.add(:warranty) do
          setcode do
            covered
          end
        end
      rescue Exception=>e
      end
    else
      Facter.debug("Error getting response from api.dell.com")
    end
  end
end

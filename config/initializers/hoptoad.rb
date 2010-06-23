HOPTOAD_YML = "#{RAILS_ROOT}/config/hoptoad.yml"

if File.exists? HOPTOAD_YML
  HoptoadNotifier.configure do |config|
    hoptoad_config = YAML.load_file(HOPTOAD_YML)[RAILS_ENV]
    config.api_key = hoptoad_config['api_key']
  end
else
  puts "hoptoad.yml not configured. Copy config/hoptoad.example.yml and set your API key to enable Hoptoad support"
end

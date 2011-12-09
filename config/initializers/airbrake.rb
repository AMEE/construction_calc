AIRBRAKE_YML = "#{RAILS_ROOT}/config/airbrake.yml"

if File.exists? AIRBRAKE_YML
  Airbrake.configure do |config|
    airbrake_config = YAML.load_file(AIRBRAKE_YML)[RAILS_ENV]
    config.api_key = airbrake_config['api_key']
  end
else
  puts "airbrake.yml not configured. Copy config/airbrake.example.yml and set your API key to enable Airbrake support"
end
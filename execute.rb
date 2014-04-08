Dir.glob("#{File.dirname(__FILE__)}/config/*").each { |file| require_relative file }
Dir.glob("#{File.dirname(__FILE__)}/lib/*").each { |file| require_relative file }

smtp_config = {
    host: 'mailtrap.io',
    port: 2525,
    address: 'mailtrap.io',
    user_name: '250929978b732beb',
    password: '63d5ecc2b2b98e',
    authentication: :cram_md5
}

monitor_config = {
    site_url: "http://ya.ru",
    email: "freeman.zhenia@gmail.com",
    appropriate_response_codes: [200, 201, 301],
    number_of_tries: 3,
    max_response_time: 30
}

yandex_monitor = SiteMonitor.new(monitor_config, smtp_config)
validate_errors = yandex_monitor.validate_attributes
if validate_errors.size > 0
  puts validate_errors
  exit
end

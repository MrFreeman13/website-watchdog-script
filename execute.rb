Dir.glob("#{File.dirname(__FILE__)}/config/*").each { |file| require_relative file }
Dir.glob("#{File.dirname(__FILE__)}/lib/*").each { |file| require_relative file }

# mailtrap.io inbox configuration. Just for testing
smtp_config = {
    host: 'mailtrap.io',
    port: 2525,
    address: 'mailtrap.io',
    user_name: '2509fe1ed9cbfe78',
    password: '7f0f9c07116d1b',
    authentication: :cram_md5
}

monitor_config = {
    site_url: "http://www.timeout.com/londondasdasd/",
    email: "freeman.zhenia@gmail.com",
    sender: "no-reply_site_watchdog@gmail.com",
    appropriate_response_codes: [200, 201, 301],
    number_of_tries: 3,
    max_response_time: 6
}

yandex_monitor = SiteMonitor.new(monitor_config, smtp_config)
validate_errors = yandex_monitor.validate_attributes
if validate_errors.size > 0
  puts validate_errors
  exit
end
yandex_monitor.start_monitoring

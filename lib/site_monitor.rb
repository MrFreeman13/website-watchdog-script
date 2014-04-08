class SiteMonitor

  attr_accessor :site_url, :email, :appropriate_response_codes,
                :number_of_tries, :max_response_time

  attr_reader :smtp_config_array

  def initialize(options={}, mail_config)
    @site_url = options[:site_url]
    @email = options[:email]
    @appropriate_response_codes = options[:appropriate_response_codes]
    @number_of_tries = options[:number_of_tries]
    @max_response_time = options[:max_response_time]
    @smtp_config_array = mail_config.values
  end
end


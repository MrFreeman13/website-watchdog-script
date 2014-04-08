class SiteMonitor

  attr_accessor :site_url, :email, :appropriate_response_codes,
                :number_of_tries, :max_response_time

  attr_reader :smtp_config_array, :valid_attributes

  def initialize(options={}, mail_config)
    @site_url = options[:site_url]
    @email = options[:email]
    @appropriate_response_codes = options[:appropriate_response_codes]
    @number_of_tries = options[:number_of_tries]
    @max_response_time = options[:max_response_time]
    @smtp_config_array = mail_config.values
    @valid_attributes = false
  end

  def validate_attributes
    errors = []
    errors << "Incorrect url address" if @site_url.match(/https?:\/\/[\S]+/).nil?
    errors << "Incorrect email address" if @email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/).nil?
    errors << "You should pass correct response codes in array" if @appropriate_response_codes.class != Array
    errors << "Incorrect number of tries" if @number_of_tries.class != Fixnum
    errors << "Incorrect max response time" if @max_response_time.class != Fixnum
    if errors == []
      @valid_attributes = true
    end
    errors
  end
end


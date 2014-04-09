class SiteMonitor

  attr_accessor :site_url, :email, :appropriate_response_codes,
                :number_of_tries, :max_response_time, :timeout_down_error, :response_code_down_error

  attr_reader :smtp_config_array, :valid_attributes

  def initialize(options={}, mail_config)
    @site_url = options[:site_url]
    @email = options[:email]
    @appropriate_response_codes = options[:appropriate_response_codes]
    @number_of_tries = options[:number_of_tries]
    @max_response_time = options[:max_response_time]
    @smtp_config_array = mail_config.values
    @valid_attributes = false
    @timeout_down_error, @response_code_down_error = nil, nil
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

  def start_monitoring
    url = URI.parse(@site_url)
    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout = @max_response_time
    http.open_timeout = @max_response_time
    http.use_ssl = true if @site_url.start_with?("https")

    loop do

      tries_counter = 0

      # Check timeout
      begin
        response = http.start() {|request| request.get(url) }
      rescue Timeout::Error
        if @timeout_down_error
          next
        else
          if tries_counter < @number_of_tries
            tries_counter += 1
            sleep 0.5
            retry
          else
            @timeout_down_error = "No response during #{@max_response_time} seconds"
            send_message(:error)
            next
          end
        end
      end

      # Check response code
      if @appropriate_response_codes.include?(response.code.to_i)
        next
      else
        @number_of_tries.times do
          response = http.start() {|request| request.get(url) }
          @response_code_down_error = "Incorrect HTTP response code - #{response.code}"
          if @appropriate_response_codes.include?(response.code.to_i)
            @response_code_down_error = nil
            break
          end
        end
        send_message(:error) if @response_code_down_error
      end
    end
  end

  private

  def send_message(reason)

  end
end


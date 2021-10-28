# require 'pry'

class TimeFormatter

  DATE_PARAMS = %w[year month day hour minute second]
  FORMAT_DIRECTIVES = {
                        "year"    => "%Y",
                        "month"   => "%m",
                        "day"     => "%d",
                        "hour"    => "%H",
                        "minute"  => "%M",
                        "second"  => "%S"
                      }
  
  attr_reader :response

  def initialize(params)
    @params = params
    @undefined_formats = []
    @response = {formatted_date: "", errors: ""}
  end

  def call
    date_params = @params.split('=').last.split('%2C')

    formatted = []
    undefined_formats = []
    
    date_params.each do |dp| 
      if DATE_PARAMS.include?(dp)
        formatted << Time.now.strftime(FORMAT_DIRECTIVES[dp])
      else
        undefined_formats << dp
      end
    end
    
    if undefined_formats.any?
      @response[:errors] = "Unknown time format [#{undefined_formats.join(', ')}]"
    else
      @response[:formatted_date] = formatted.join('-')
    end
  end

end
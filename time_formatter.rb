# require 'pry'

class TimeFormatter

  FORMAT_DIRECTIVES = {
                        "year"    => "%Y",
                        "month"   => "%m",
                        "day"     => "%d",
                        "hour"    => "%H",
                        "minute"  => "%M",
                        "second"  => "%S"
                      }

  def initialize(params)
    @params = params
    @defined_formats = []
    @undefined_formats = []
  end

  def call
    date_params = @params.split('=').last.split('%2C') 
    @defined_formats, @undefined_formats = date_params.partition { |dp| FORMAT_DIRECTIVES.keys.include?(dp) }
  end

  def success?
    field_name_valid? && @undefined_formats.empty?
  end

  def time_string
    Time.now.strftime(FORMAT_DIRECTIVES.values_at(*@defined_formats).join('-'))
  end

  def invalid_string
    return 'Bad request' unless field_name_valid?
    "Unknown time format [#{@undefined_formats.join(', ')}]"
  end

  private

  def field_name_valid?
    @params.split('=').first == 'format'
  end
end


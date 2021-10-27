class App

  DATE_PARAMS = %w[year month day hour minute second]
  FORMAT_DIRECTIVES = {
                        "year"    => "%Y",
                        "month"   => "%m",
                        "day"     => "%d",
                        "hour"    => "%H",
                        "minute"  => "%M",
                        "second"  => "%S"
                      }

  def call(env)
    status, body = parse_request(env)
    [status, headers, body]
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def parse_request(env)
    return [404, ["Not Found"]]    unless env["PATH_INFO"] == '/time'
    return [400, ["Bad request"]]  unless env["QUERY_STRING"] =~ /format=.+/

    date_params = env["QUERY_STRING"].split('=').last.split('%2C')

    undefined_formats = []
    date_params.each { |dp| undefined_formats << dp unless DATE_PARAMS.include?(dp) }
    return [400, ["Unknown time format [#{undefined_formats.join(', ')}]"]] if undefined_formats.any?
    
    [200, [format_date(date_params)]]
  end

  def format_date(date_params)
    Time.now.strftime(date_params.map {|dp| FORMAT_DIRECTIVES[dp]}.join('-'))
  end

end
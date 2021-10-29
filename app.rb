require_relative 'time_formatter'

class App

  def call(env)
    @request = Rack::Request.new(env)
    response.finish
  end

  private

  def response
    status, body = parse_request
    Rack::Response.new(body, status, headers)
  end

  def headers
    { 'Content-Type' => 'text/plain; charset=utf-8' }
  end

  def parse_request
    if @request.path_info == '/time'
      format_time
    else
      [404, ["Not Found"]]
    end
  end

  def format_time
    return [400, ["Bad request"]] unless @request.query_string =~ /format=.+/ 
    
    formatted = TimeFormatter.new(@request.query_string).call
    [formatted.first ? 200 : 400, [formatted.last]]
  end
end
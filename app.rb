require_relative 'time_formatter'
class App

  def call(env)
    request = Rack::Request.new(env)
    r = response(request)
    r.finish
  end

  def response(request)
    r = Rack::Response.new
    r.set_header('Content-Type', 'text/plain; charset=utf-8')

    if request.path_info == '/time'
      r.status, r.body = 400, ["Bad request"] unless request.query_string =~ /format=.+/  

      tf = TimeFormatter.new(request.query_string)
      tf.call
      if tf.response[:errors].empty?
        r.status, r.body = 200, [tf.response[:formatted_date]]
      else
        r.status, r.body = 400, [tf.response[:errors]]
      end

    else
      r.status, r.body = 404, ["Not Found"] 
    end
    r
  end

end
require_relative 'time_formatter'

class App

  def call(env)
    if env["PATH_INFO"] == '/time'
      handle_request(env["QUERY_STRING"])
    else
      response(404, "Wrong path")
    end
  end

  def response(status, body)
    Rack::Response.new(body, status, headers).finish
  end

  def headers
    { 'Content-Type' => 'text/plain; charset=utf-8' }
  end

  def handle_request(params)
    tf = TimeFormatter.new(params)
    tf.call
    if tf.success?
      response(200, tf.time_string)
    else
      response(400, tf.invalid_string)
    end
  end
end
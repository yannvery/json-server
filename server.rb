require 'json'
require 'rack'

file = File.read('db.json')
my_hash = JSON.parse(file)



app = Proc.new do |env|
  request = Rack::Request.new(env)

  if request.path == "/kings"
    result = my_hash["kings"].select do |king|
      request.params.map do |key, value|
        king[key].to_s == value.to_s
      end.reduce(:&)
    end

    ['200', {'Content-Type' => 'application/json'}, [result.to_json]]
  else
    ['200', {'Content-Type' => 'application/json'}, [my_hash.to_json]]
  end

end

Rack::Handler::WEBrick.run app

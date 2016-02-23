require 'json'
require 'rack'
require_relative 'json_parser'
app = Proc.new do |env|
  request = Rack::Request.new(env)
  parser = JsonParser.new('db.json')
  result = parser.collection(request.path.gsub('/',''))

  if !request.params.empty?
    result = parser.select(request.path.gsub('/',''), request.params)
  end
  ['200', {'Content-Type' => 'application/json'}, [result.to_json]]
end

Rack::Handler::WEBrick.run app

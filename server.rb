require 'json'
require 'rack'

file = File.read('db.json')
my_hash = JSON.parse(file)

app = Proc.new do |env|
  ['200', {'Content-Type' => 'application/json'}, [my_hash.to_json]]
end

Rack::Handler::WEBrick.run app

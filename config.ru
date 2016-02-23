require_relative "server"
Rack::Handler::WEBrick.run Server.new

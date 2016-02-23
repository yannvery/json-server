require 'json'
require 'rack'
require 'pry'
require_relative 'json_parser'


class Server

  def initialize
    @parser = JsonParser.new('db.json')
  end

  def call(env)
    request = Rack::Request.new(env)

    method = request.request_method.downcase
    send(method, request)
  end

  def get(request)
    result = @parser.collection(request.path.gsub('/',''))
    if !request.params.empty?
      result = @parser.select(request.path.gsub('/',''), request.params)
    end
    if result
      ['200', { 'Content-Type' => 'application/json' }, [result.to_json]]
    else
      ['404', {'Content-Type' => 'application/json'}, []]
    end
  end

  def post(request)
    @parser.add(request.path.gsub('/',''), request.params)
    ['200', { 'Content-Type' => 'application/json' }, ['ok']]
  end
end

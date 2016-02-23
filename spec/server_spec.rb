require 'spec_helper'

require_relative "../server"

describe Server do
  include Rack::Test::Methods

  def app
    Server
  end

  it "returns kings" do
    get "/kings"
    expect(last_response.status).to eq 200
  end

  it "returns a 404 for a collection that doesn't exist" do
    get "/poireaux"
    expect(last_response.status).to eq 404
  end

  describe "filtering" do
    it "returns items that match the params" do
      get "/kings", id: 1

      filtered_kings = JSON.parse(last_response.body)
      expect(filtered_kings.count).to eq 1
    end
  end

  it "creates items" do
    post "/kings", {
      country: "United Kingdom",
      house: "House of Brittany",
      name: "William the Conqueror",
      years: "1106"
    }
    get "/kings", name: "William the Conqueror"

    william = JSON.parse(last_response.body)
    expect(william.count).to eq 1
  end

end


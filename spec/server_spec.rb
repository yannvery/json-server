require 'spec_helper'

require_relative "../server"

describe Server do
  include Rack::Test::Methods

  def app
    Server.new
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

  describe "creating items" do
    let(:william) { JSON.parse(last_response.body) }

    context "for an existing collection" do
      before do
        post "/kings", {
          country: "United Kingdom",
          house: "House of Brittany",
          name: "William the Conqueror",
          years: "1106"
        }
        get "/kings", name: "William the Conqueror"
      end

      it "creates items" do
        expect(william.count).to eq 1
      end

      it "creates ids for the new items" do
        expect(william.first["id"]).to eq 6
      end
    end

    context "for a new collection" do
      before do
        post "/queens", {
          country: "United Kingdom",
          house: "House of Brittany",
          name: "Elizabeth II",
          years: "1950"
        }
        get "/queens", name: "Elizabeth II"
      end

      it "creates the new collection and the item" do
        expect(elizabeth["id"]).to eq 1
      end

      let(:elizabeth) { JSON.parse(last_response.body).first }
    end
  end

end

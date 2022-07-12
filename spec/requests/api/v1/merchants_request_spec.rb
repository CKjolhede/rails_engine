require 'rails_helper'

RSpec.describe "Merchants API" do
  it "sends a list of all merchants" do

    get '/api/v1/merchants'

expect(response).to be_successful
response_body = JSON.parse(response.body, {symbolize_names: true})  
merchants = response_body[:data]

  end
end
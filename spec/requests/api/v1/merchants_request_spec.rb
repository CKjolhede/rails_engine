require 'rails_helper'

RSpec.describe "Merchants API" do
  it "sends a list of all merchants" do

    get "/api/v1/merchants"
    expect(response).to be_successful
    
    merchants = JSON.parse(response.body, symbolize_names: true)  
  # binding.pry
  end

  it 'can get one merchant' do
    get "/api/v1/merchants/42"

    expect(response).to have_https_status(200)
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:attributes]).to include(:name)
  end

end
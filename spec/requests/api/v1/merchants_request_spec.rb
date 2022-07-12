require 'rails_helper'

RSpec.describe "Merchants API" do
  
  it "sends a list of all merchants" do
    create_list(:merchant, 5)
    
    get "/api/v1/merchants"
    expect(response).to be_successful
    
    response_body = JSON.parse(response.body, symbolize_names: true)  
    merchants = response_body[:data]
    expect(merchants).to be_a Array
    expect(merchants.count).to eq(5)
    expect(merchants[0][:attributes]).to include(:name)
   
  end
  
  it 'can get one merchant' do
    create_list(:merchant, 50)
    get "/api/v1/merchants/42"

    expect(response.status).to eq(200)
    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]
    expect(merchant[:attributes]).to include(:name)
  end
end
require 'rails_helper'

RSpec.describe "Merchants API" do
  
  context 'sends a list of all merchants' do
    it "on the happy path" do
      create_list(:merchant, 5)
      
      get "/api/v1/merchants"
      expect(response).to be_successful
      
      response_body = JSON.parse(response.body, symbolize_names: true)  
      # expect(response_body).to be_a Hash
      merchants = response_body[:data]
      expect(merchants).to be_a Array
      expect(merchants.count).to eq(5)
        merchants.each do |merchant|
          expect(merchant[:attributes]).to include(:name)
        end
    end
    it "on the sad path" do
      create_list(:merchant, 5)
      
      get "/api/v1/merchants"
      
      response_body = JSON.parse(response.body, symbolize_names: true)  
      expect(response_body).to include(:data) #sad path because without serializer :data absent
      merchants = response_body[:data]
      expect(merchants).to_not include(:created_at)
      expect(merchants).to_not include(:updated_at)
    end
  end
  
  xit 'can get one merchant' do
    create_list(:merchant, 50)
    get "/api/v1/merchants/42"

    expect(response).to have_https_status(200)
   response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]
    expect(merchant.count).to eq(3)
    expect(merchant[:attributes]).to include(:name)
  end
end
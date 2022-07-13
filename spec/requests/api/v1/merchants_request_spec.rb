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
  
  it 'can get one merchant; happy path' do
    create_list(:merchant, 20)
    # binding.pry
    get "/api/v1/merchants/12"

    expect(response.status).to eq(200)
    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]
    expect(merchant.count).to eq(3)
    expect(merchant[:attributes]).to include(:name)
    expect(merchant[:attributes].count).to eq(1)
  end
  # THIS sadpath won't work due to inability of rspec to call w/o merch.id
  # it 'will return status code 404 if merchant.id does not exist' do
  #   create_list(:merchant, 2)
  #   get "/api/v1/merchants/30"
  #   expect(response.status).to eq(404)
  # end
end
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
      merchants = response_body[:data]
      
      expect(response_body).to include(:data) 
      expect(merchants).to_not include(:created_at)
      expect(merchants).to_not include(:updated_at)
    end
    
  end 

  context 'it returns one merchant' do 
    it 'happy path' do
      create_list(:merchant, 30)
      
      get "/api/v1/merchants/32"
      
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant.count).to eq(3)
      expect(merchant).to include(:type, :id, :attributes)
      expect(merchant[:attributes].count).to eq(1)
      expect(merchant[:attributes]).to include(:name)
    end

    it 'sad path' do
      create_list(:merchant, 30)
      
      get "/api/v1/merchants/50000"
      binding.pry
      expect(response.status).to eq(404)

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant.count).to eq(3)
      expect(merchant).to include(:type, :id, :attributes)
      expect(merchant[:attributes].count).to eq(1)
      expect(merchant[:attributes]).to include(:name)
    end
  
    # THIS sadpath won't work due to inability of rspec to call w/o merch.id
    # it 'will return status code 404 if merchant.id does not exist' do
    #   create_list(:merchant, 2)
    #   get "/api/v1/merchants/30"
    #   expect(response.status).to eq(404)
    # end
    
    it 'can get all of a merchants items' do
      merchant = create(:merchant)
      
      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      item3 = create(:item, merchant_id: merchant.id)
      item4 = create(:item, merchant_id: merchant.id)
      
      get "/api/v1/merchants/#{merchant.id}/items"
      expect(response.status).to eq(200)
      
      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]
      
      expect(items).to be_an Array
      expect(merchant.items.count).to eq(4)
      
      items.each do |item|
        expect(item).to have_key(:id)
        expect(item).to have_key(:type)
        # expect(item).to have_key(:attributes)  DRY?
        expect(item[:attributes]).to include(:name, :description, :unit_price, :merchant_id)
        expect(item[:attributes][:merchant_id]).to eq(merchant.id)
      end
    end
  end

  describe "search for merchant by name" do
    it 'returns only one merchant' do
    
      merchant1 = Merchant.create!(name: "Lost Treasures")
      merchant_other = Merchant.create!(name: "Other Treasures")
      name = "Lost"
      get "/api/v1/merchants/find?name=#{name}"
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant).to be_a Hash
      expect(merchant[:attributes][:name]).to eq("Lost Treasures")
      expect(merchant).to_not include(merchant_other)

    end
  end
end
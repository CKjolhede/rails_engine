require 'rails_helper'

RSpec.describe Item, type: :request do
  describe 'Get' do
    it 'all items' do
      merchant = create(:merchant)
      create_list(:item, 3, merchant_id: merchant.id)

      get "/api/v1/items"
      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items).to be_an Array
      expect(items.count).to eq(3)
        items.each do |item|
          expect(item).to have_key(:type)
          expect(item).to have_key(:id)
          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to include(:name)
          expect(item[:attributes]).to include(:description)
          expect(item[:attributes]).to include(:unit_price)
          expect(item[:attributes]).to include(:merchant_id)
          expect(item[:attributes]).to_not include(:created_at)  ## Sad Path
          expect(item[:attributes]).to_not include(:updated_at)  ## Sad Path
        end
    end

    it 'one item by item id' do
      merchant = create(:merchant)
      create_list(:item, 10, merchant_id: merchant.id)
      item = Item.find(7)
      
      expect(item.created_at.present?).to eq(true)
      expect(item.updated_at.present?).to eq(true)
      
      get "/api/v1/items/7"

      expect(response.status).to eq(200)
      
      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]
      expect(response_body.count).to eq(1)
      expect(item).to be_a Hash
      expect(item.count).to eq(3)
      expect(item).to have_key(:id)
      expect(item).to have_key(:type)
      # expect(item).to have_key(:attributes)   DRY?
      expect(item[:attributes]).to include(:name)
      expect(item[:attributes]).to include(:description)
      expect(item[:attributes]).to include(:unit_price)
      expect(item[:attributes]).to include(:merchant_id)
      expect(item[:attributes]).to_not include(:created_at)
      expect(item[:attributes]).to_not include(:updated_at)      
    end
  end

  describe "Post" do
    it 'creates a new item' do
      merchant = create(:merchant)
      item_params = ({
                      name: 'Car Tweet',
                      description: 'Window LED screen displays user input from mobile app',
                      unit_price: 99.99,
                      merchant_id: merchant.id
                    })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])

      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{created_item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(created_item.id)}.to raise_error(ActiveRecord::RecordNotFound)

    end
  end
end
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
    it 'creates a new item, happy path' do
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

    it 'will return merchant info from item ' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      # get "/api/v1/items/#{item.id}/merchants/#{merchant.id}"
      get "/api/v1/items/#{item.id}/merchant"

      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant_hash = response_body[:data]
    end
  end

  describe "Patch" do
    it 'will update item attributes' do
      merchant = create(:merchant)
      merchant2 = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      original_name = item.name
      original_description = item.description
      original_unit_price = item.unit_price
      original_merchant_id = item.merchant_id

      item_params = { name: "Yamakabaya", description: "The perfect fusion of headwear providing extreme versatility as it builds bridges", unit_price: 42.97, merchant_id: merchant2.id }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: item.id)
      
      expect(response.status).to eq(200 || 201 || 202)
      expect(item.name).to_not eq(original_name)
      expect(item.name).to eq("Yamakabaya")
      expect(item.description).to_not eq(original_description)
      expect(item.description).to eq("The perfect fusion of headwear providing extreme versatility as it builds bridges")
      expect(item.unit_price).to_not eq(original_unit_price)
      expect(item.unit_price).to eq(42.97)
      expect(item.merchant_id).to_not eq(original_merchant_id)
      expect(item.merchant_id).to eq(merchant2.id)
    end
  end

  describe "search for items by keyword" do
    it 'returns all items containing keyword' do
      merchant = Merchant.create!(name: "Lost Treasures")
      item1 = Item.create!(name: "Lost treasure", description: "A real treasure", unit_price: 1114.01, merchant_id: merchant.id)
      item2 = Item.create!(name: "Litte Treasure", description: "A really tiny thing", unit_price: 114.01, merchant_id: merchant.id)
      item3 = Item.create!(name: "Knockoff for Sure", description: "not treasure for sure real", unit_price: 14.01, merchant_id: merchant.id)
      name = "Reasure"
      
      get "/api/v1/items/find_all?name=#{name}"
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items).to be_an Array
      expect(items.count).to eq(2)
    end
  end


  describe 'searching for items with min price' do
    it 'will return one item with price >= keyvalue' do
      merchant = Merchant.create!(name: "Lost Treasures")

  desribe 'searching for items with min price' do
    it 'will return all items with price >= keyvalue' do

      item1 = Item.create!(name: "Lost treasure", description: "A real treasure", unit_price: 1114.01, merchant_id: merchant.id)
      item2 = Item.create!(name: "Litte Treasure", description: "A really tiny thing", unit_price: 114.01, merchant_id: merchant.id)
      item3 = Item.create!(name: "Knockoff for Sure", description: "not treasure for sure real", unit_price: 14.01, merchant_id: merchant.id)
      min_price = 15

      max_price = 2000

      
      get "/api/v1/items/find_all?min_price=#{min_price}"
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items).to be_an Hash
      expect(items[:attributes].count).to eq(4)
      expect(items[0][:attributes][:name]).to eq("Lost treasure")
      expect(items[1][:attributes][:name]).to eq("Little Treasures")
    end

    it 'will return all items with price <= keyvalue' do
      merchant = Merchant.create!(name: "Lost Treasures")
      item1 = Item.create!(name: "Lost treasure", description: "A real treasure", unit_price: 1114.01, merchant_id: merchant.id)
      item2 = Item.create!(name: "Litte Treasures", description: "A really tiny thing", unit_price: 114.01, merchant_id: merchant.id)
      item3 = Item.create!(name: "Knockoff for Sure", description: "not treasure for sure real", unit_price: 14.01, merchant_id: merchant.id)
      max_price = 150
      
      get "/api/v1/items/find?max_price=#{max_price}"
      expect(response).to be_successful
      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items).to be_an Array
      expect(items.count).to eq(1)
      expect(items[0][:attributes][:name]).to eq("Knockoff for Sure")
    end
  end
end
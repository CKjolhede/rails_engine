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
          expect(item[:attributes]).to include(:name)
          expect(item[:attributes]).to include(:description)
          expect(item[:attributes]).to include(:unit_price)
          expect(item[:attributes]).to include(:merchant_id)
          expect(item[:attributes]).to_not include(:created_at)  ## Sad Path
          expect(item[:attributes]).to_not include(:updated_at)  ## Sad Path
        end
    end
  end
end
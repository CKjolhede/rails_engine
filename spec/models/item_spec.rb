require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships and validations" do
    it { should belong_to :merchant}

    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
    it {should validate_presence_of :merchant_id}
  end

  describe 'class methods' do
    it '#search returns all items with search term in name' do
      merchant = Merchant.create!(name: "Lost Treasures")
      item1 = Item.create!(name: "Lost treasure", description: "A real treasure", unit_price: 1114.01, merchant_id: merchant.id)
      item2 = Item.create!(name: "Litte Treasure", description: "A really tiny thing", unit_price: 114.01, merchant_id: merchant.id)
      item3 = Item.create!(name: "Knockoff for Sure", description: "not treasure for sure real", unit_price: 14.01, merchant_id: merchant.id)
  
      expect(Item.search("Reasure")).to match_array([item1, item2])

    end 
  end
end
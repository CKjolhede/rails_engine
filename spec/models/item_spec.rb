require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships and validations" do
    it { should belong_to :merchant}

    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
    it {should validate_presence_of :merchant_id}
  end

  describe "class methods" do
    it '#search returns all items with search term in name' do
      merchant = Merchant.create!(name: "Lost Treasures")
      item1 = Item.create!(name: "Lost treasure", description: "A real treasure", unit_price: 1114.01, merchant_id: merchant.id)
      item2 = Item.create!(name: "Litte Treasure", description: "A really tiny thing", unit_price: 114.01, merchant_id: merchant.id)
      item3 = Item.create!(name: "Knockoff for Sure", description: "not treasure for sure real", unit_price: 14.01, merchant_id: merchant.id)
  
      expect(Item.search("Reasure")).to match_array([item1, item2])
    end

    it 'destroys invoices with only this item' do 
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      invoice1 = create(:invoice)
      InvoiceItem.create(invoice:invoice1, item:item1)
      invoice2 = create(:invoice)
      InvoiceItem.create(invoice:invoice2, item:item1)
      InvoiceItem.create(invoice:invoice2, item:item2)

      item1.destroy_one_item_invoices
      invoices=Invoice.all 	

      expect(invoices.count).to eq(1)
      expect(invoices[0].id).to eq(invoice2.id)
    end
  end
end
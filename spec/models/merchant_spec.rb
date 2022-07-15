require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships and validations" do
    it { should have_many :items}

    it {should validate_presence_of :name}
  end

  describe "class methods" do
    it 'will return all merchants with names containint keyword' do
      merchant = Merchant.create!(name: "Don't find me")
      merchant2 = Merchant.create!(name: "Found me")

    keyword = "Me"
    expect(Merchant.search(keyword)).to eq(merchant)
    end
  end
end
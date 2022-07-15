class Item < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name, :description, :unit_price, :merchant_id

  def self.search(name)
    where('name ILIKE ?',"%#{name}%")
  end
  
  def self.search_minmax_price(min, max)
      where("? <= unit_price and unit_price <= ?", "#{min.to_i}", "#{max.to_i}")
  end

  def self.search_min_price(min_price)
    where("unit_price >= ?", "#{min_price}")
  end

  def self.search_max_price(max_price)
    where("unit_price <= ?", "#{max_price.to_i}")
  end
end
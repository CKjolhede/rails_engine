class Item < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name, :description, :unit_price, :merchant_id

  def self.search(name)
    where('name ILIKE ?',"%#{name}%")
  end

  def self.search_min_price(min_price)
    if min_price.to_i < 0
        ErrorSerializer.neg_min(400)
    else
      where(unit_price > min_price.to_i).first
    end
  end

  def self.search_max_price(max_price)
    if max_price.to_i < 0
      ErrorSerializer.neg_min(400)
    else
      where(unit_price > max_price.to_i).first
    end
  end

  def self.search_minmax_price(min_price, max_price)
    if min_price.to_i < 0
      ErrorSerializer.neg_min(400)
    elsif max_price.to_i < 0
      ErrorSerializer.neg_min(400)
    elsif min_price.to_i > max_price.to_i
      ErrorSerializer.min_over_max(400)
    else 
      where(unit_price: min_price.to_i .. max_price.to_i).first
    end
  end

  def self.search_price(params)
    if params[:name]
      ErrorSerializer.with_name(404) 
    elsif params[:min_price] && !params[:max_price]
      self.search_min_price(params[:min_price]) 
    elsif !params[:min_price] && params[:max_price]
      self.search_max_price(params[:max_price])
    elsif params[:min_price] && params[:max_price]
      self.search_maxmin_price(params[:min_price], params[:max_price]) 
    else
      ErrorSerializer.invalid(status: 400)
    end
  end
end
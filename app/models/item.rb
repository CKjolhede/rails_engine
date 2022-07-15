class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  validates_presence_of :name, :description, :unit_price, :merchant_id

  def self.search(name)
    where('name ILIKE ?',"%#{name}%")
  end

  def self.search_min_price(min_price)
    if min_price.to_i < 0
        ErrorSerializer.neg_min(400)
    else
      where("unit_price > #{min_price.to_i}").first
    end
  end

  def self.search_max_price(max_price)
    if max_price.to_i < 0
      ErrorSerializer.neg_min(400)
    else
      where("unit_price > #{max_price.to_i}").first
    end
  end

  def self.search_minmax_price(min_price, max_price)
    binding.pry
    if min_price.to_i < 0
      ErrorSerializer.neg_min(400)
    elsif max_price.to_i < 0
      ErrorSerializer.neg_min(400)
    elsif min_price.to_i > max_price.to_i
      ErrorSerializer.min_over_max(400)
    else 
      where("#{min_price.to_i} < unit_price <  #{max_price.to_i}").first
    end
  end

  def self.search_price(params)
    if params[:name]
      ErrorSerializer.with_name(400) 
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

  def destroy_one_item_invoices
      the_invoices = Invoice.joins(:items).group(:id).having("count(item_id) = 1")
      Invoice.where(id: the_invoices.pluck(:id)).destroy_all
  end
end
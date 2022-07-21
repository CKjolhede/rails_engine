class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.search(name)
    where('name ILIKE ?',"%#{name}%").order(:name).first
  end


  def self.top_merchants_by_revenue(quantity)
    joins(invoices: [:invoice_items, :transactions]).where(transactions: {result: 'success'}, invoices: {status: 'shipped'}).select(:name, :id, 'SUM(invoice_items.quantity * invoice_items.unit_price) as revenue').group(:id).order(revenue: :desc).limit(quantity)
  end
end
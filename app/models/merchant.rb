class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

   def self.top_merchants_by_revenue(quantity)
     Merchant.select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as revenue')
       .joins(invoices: [:invoice_items, :transactions])
       .group(:id)
       .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
       .order(revenue: :desc)
       .limit(quantity)
   end

   def self.top_merchants_by_items_sold(quantity)
  #   Merchant.joins(invoices: :invoice_items.select('merchants.*, SUM(invoice_items.quantity) as count')
   end

  def self.search_return_one(search_params)
    where("name ILIKE ?", "%#{search_params}%").order(:name).first
  end

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end

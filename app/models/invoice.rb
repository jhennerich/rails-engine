class Invoice < ApplicationRecord
  validates_presence_of :status
  validates_presence_of :customer_id

  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants
  has_many :transactions

  enum status: {"in progress" => 0, "completed" => 1, "cancelled" => 2}

  def self.pending_invoices
    where(status: 0)
    .order(:created_at)
  end

  def format_time
    created_at.strftime('%A, %B %e, %Y')
  end

  def total_rev
    invoice_items.sum("quantity * unit_price")
  end

  def qualifiy_for_discount?
      invoice_items.joins(:bulk_discounts)
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
  end

  def total_discount
      discount = invoice_items.joins(:bulk_discounts)
              .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
              .select('invoice_items.*, max(invoice_items.unit_price * invoice_items.quantity *(bulk_discounts.percentage)/100.00) as total_discount')
              .group('invoice_items.id')
              .sum(&:total_discount)
  end

  def total_discounted_rev
    total_rev - total_discount
  end
end

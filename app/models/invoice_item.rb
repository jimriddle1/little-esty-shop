class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants

  enum status: %w[pending packaged shipped]

  def self.item_revenue
    sum('quantity * unit_price')
  end

  def applied_discounts
    bulk_discounts
    .where('bulk_discounts.quantity_threshold <= ?', self.quantity)
    .order('bulk_discounts.quantity_threshold desc')
    .first
  end
end

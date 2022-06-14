class Invoice < ApplicationRecord
  belongs_to :customer

  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: ['in progress', 'cancelled', 'completed']

  def get_invoice_item(item_id)
    invoice_items.find_by(item_id: item_id)
  end

  def total_revenue(merchant_id)
    invoice_items.joins(:item)
                 .where(items: { merchant_id: merchant_id })
                 .sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def self.incomplete
    joins(:invoice_items)
      .where.not(invoice_items: { status: 2 })
      .group(:id)
      .select('invoices.*')
      .order(created_at: :asc)
  end

  def invoice_revenue
    invoice_items.joins(:item).sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def discounted_revenue
    discount = invoice_items
      .joins(:bulk_discounts)
      .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
      .select('invoice_items.id, max((bulk_discounts.percentage_discount) * (invoice_items.quantity * invoice_items.unit_price)) as discount_total')
      .group('invoice_items.id')
      .sum(&:discount_total)/100

    invoice_revenue - discount
  end
end

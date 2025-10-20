class Transaction < ApplicationRecord
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: %w[in out] }
  validate :sufficient_stock, if: -> { transaction_type == 'out' }

  after_create :apply_stock_change

  private

  def sufficient_stock
    if product.stock < quantity
      errors.add(:base, "Insufficient stock for product #{product.name}")
    end
  end

  def apply_stock_change
    case transaction_type
    when 'in'
      product.increment!(:stock, quantity)
    when 'out'
      product.decrement!(:stock, quantity)
    end
  end
end
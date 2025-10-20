class Transaction < ApplicationRecord
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: %w[in out] }

  # Use a callback to handle stock update automatically
  after_create :update_product_stock

  private

  def update_product_stock
    if transaction_type == 'in'
      product.increment!(:stock, quantity)
    elsif transaction_type == 'out'
      if product.stock >= quantity
        product.decrement!(:stock, quantity)
      else
        raise ActiveRecord::Rollback, "Insufficient stock for product #{product.name}"
      end
    end
  end
end
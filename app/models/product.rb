class Product < ApplicationRecord
  has_many :transactions, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
end

class Product < ApplicationRecord
  LOW_STOCK_THRESHOLD = 10

  scope :low_stock, -> { where("quantity <= ?", LOW_STOCK_THRESHOLD) }
  scope :search, ->(query) { where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%") }

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def low_stock?
    quantity <= LOW_STOCK_THRESHOLD
  end
end

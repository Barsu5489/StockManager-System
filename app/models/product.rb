class Product < ApplicationRecord
  LOW_STOCK_THRESHOLD = 10

  has_one_attached :image

  scope :low_stock, -> { where("quantity <= ?", LOW_STOCK_THRESHOLD) }
  scope :search, ->(query) { where("name LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%") }

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def low_stock?
    quantity <= LOW_STOCK_THRESHOLD
  end

  def self.to_csv
    require "csv"
    CSV.generate(headers: true) do |csv|
      csv << [ "Name", "Description", "Price", "Quantity", "Low Stock", "Created At", "Updated At" ]
      all.find_each do |product|
        csv << [
          product.name,
          product.description,
          product.price,
          product.quantity,
          product.low_stock? ? "Yes" : "No",
          product.created_at,
          product.updated_at
        ]
      end
    end
  end
end

require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # Validations
  test "should be valid with all required attributes" do
    product = Product.new(name: "Test Product", price: 10.00, quantity: 5)
    assert product.valid?
  end

  test "should require name" do
    product = Product.new(price: 10.00, quantity: 5)
    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "should require price" do
    product = Product.new(name: "Test", quantity: 5)
    assert_not product.valid?
    assert_includes product.errors[:price], "can't be blank"
  end

  test "should require quantity" do
    product = Product.new(name: "Test", price: 10.00)
    assert_not product.valid?
    assert_includes product.errors[:quantity], "can't be blank"
  end

  test "price must be non-negative" do
    product = Product.new(name: "Test", price: -1, quantity: 5)
    assert_not product.valid?
    assert_includes product.errors[:price], "must be greater than or equal to 0"
  end

  test "quantity must be non-negative integer" do
    product = Product.new(name: "Test", price: 10.00, quantity: -1)
    assert_not product.valid?
    assert_includes product.errors[:quantity], "must be greater than or equal to 0"
  end

  # Low stock threshold
  test "LOW_STOCK_THRESHOLD is 10" do
    assert_equal 10, Product::LOW_STOCK_THRESHOLD
  end

  test "low_stock? returns true when quantity is at threshold" do
    product = Product.new(name: "Test", price: 10.00, quantity: 10)
    assert product.low_stock?
  end

  test "low_stock? returns true when quantity is below threshold" do
    product = products(:low_stock)
    assert product.low_stock?
  end

  test "low_stock? returns false when quantity is above threshold" do
    product = products(:one)
    assert_not product.low_stock?
  end

  # Scopes
  test "low_stock scope returns products at or below threshold" do
    low_stock_products = Product.low_stock
    assert_includes low_stock_products, products(:two)
    assert_includes low_stock_products, products(:low_stock)
    assert_includes low_stock_products, products(:out_of_stock)
    assert_not_includes low_stock_products, products(:one)
  end

  test "search scope finds products by name" do
    results = Product.search("Widget")
    assert_includes results, products(:one)
    assert_not_includes results, products(:two)
  end

  test "search scope finds products by description" do
    results = Product.search("fancy")
    assert_includes results, products(:two)
  end

  test "search scope is case insensitive" do
    results = Product.search("widget")
    assert_includes results, products(:one)
  end

  # CSV export
  test "to_csv generates valid CSV" do
    csv = Product.to_csv
    assert_includes csv, "Name"
    assert_includes csv, "Description"
    assert_includes csv, "Price"
    assert_includes csv, "Quantity"
    assert_includes csv, "Low Stock"
  end

  test "to_csv includes product data" do
    csv = Product.to_csv
    assert_includes csv, "Widget"
    assert_includes csv, "Gadget"
  end

  test "to_csv shows Yes for low stock products" do
    csv = Product.where(id: products(:low_stock).id).to_csv
    assert_includes csv, "Yes"
  end

  test "to_csv shows No for normal stock products" do
    csv = Product.where(id: products(:one).id).to_csv
    assert_includes csv, "No"
  end
end

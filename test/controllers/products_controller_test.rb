require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @low_stock_product = products(:low_stock)
    @user = users(:one)
    sign_in_as(@user)
  end

  # Index
  test "should get index" do
    get products_url
    assert_response :success
    assert_select "h1", "Inventory"
  end

  test "index should display products" do
    get products_url
    assert_response :success
    assert_match @product.name, response.body
  end

  test "index should show low stock alert when products are low" do
    get products_url
    assert_response :success
    assert_match "Low Stock Alert", response.body
  end

  # Search and Filter
  test "should filter by search query" do
    get products_url, params: { query: "Widget" }
    assert_response :success
    assert_match "Widget", response.body
  end

  test "should filter by low stock" do
    get products_url, params: { filter: "low_stock" }
    assert_response :success
    assert_match @low_stock_product.name, response.body
  end

  # CSV Export
  test "should export CSV" do
    get products_url(format: :csv)
    assert_response :success
    assert_equal "text/csv", response.content_type
    assert_match "Name", response.body
    assert_match @product.name, response.body
  end

  test "CSV export respects search filter" do
    get products_url(format: :csv, query: "Widget")
    assert_response :success
    assert_match "Widget", response.body
    assert_no_match(/Gadget/, response.body)
  end

  # Show
  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  # New
  test "should get new" do
    get new_product_url
    assert_response :success
  end

  # Create
  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { name: "New Product", description: "Description", price: 15.99, quantity: 10 } }
    end
    assert_redirected_to product_url(Product.last)
  end

  test "should not create product without name" do
    assert_no_difference("Product.count") do
      post products_url, params: { product: { description: "Description", price: 15.99, quantity: 10 } }
    end
    assert_response :unprocessable_entity
  end

  test "should not create product with negative price" do
    assert_no_difference("Product.count") do
      post products_url, params: { product: { name: "Test", price: -5, quantity: 10 } }
    end
    assert_response :unprocessable_entity
  end

  # Edit
  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  # Update
  test "should update product" do
    patch product_url(@product), params: { product: { name: "Updated Name" } }
    assert_redirected_to product_url(@product)
    @product.reload
    assert_equal "Updated Name", @product.name
  end

  test "should not update product with invalid data" do
    patch product_url(@product), params: { product: { name: "" } }
    assert_response :unprocessable_entity
  end

  # Destroy
  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end
    assert_redirected_to products_url
  end

  # Stock adjustment
  test "should increase stock" do
    original_quantity = @product.quantity
    post increase_stock_product_url(@product)
    @product.reload
    assert_equal original_quantity + 1, @product.quantity
  end

  test "should decrease stock" do
    original_quantity = @product.quantity
    post decrease_stock_product_url(@product)
    @product.reload
    assert_equal original_quantity - 1, @product.quantity
  end

  test "should not decrease stock below zero" do
    out_of_stock = products(:out_of_stock)
    post decrease_stock_product_url(out_of_stock)
    out_of_stock.reload
    assert_equal 0, out_of_stock.quantity
  end

  # Turbo Stream responses
  test "increase_stock responds with turbo_stream" do
    post increase_stock_product_url(@product), as: :turbo_stream
    assert_response :success
    assert_match "turbo-stream", response.content_type
  end

  test "decrease_stock responds with turbo_stream" do
    post decrease_stock_product_url(@product), as: :turbo_stream
    assert_response :success
    assert_match "turbo-stream", response.content_type
  end

  # Authentication
  test "should redirect to login when not authenticated" do
    # Reset session and make a fresh request without signing in
    reset!
    get products_url
    assert_redirected_to new_session_url
  end
end

class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy increase_stock decrease_stock ]

  # GET /products or /products.json or /products.csv
  def index
    @products = current_user.products
    @products = @products.search(params[:query]) if params[:query].present?
    @products = @products.low_stock if params[:filter] == "low_stock"
    @low_stock_products = current_user.products.low_stock

    respond_to do |format|
      format.html
      format.csv do
        send_data @products.to_csv, filename: "inventory-#{Date.current}.csv", type: "text/csv"
      end
    end
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = current_user.products.build
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = current_user.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, notice: "Product was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # POST /products/1/increase_stock
  def increase_stock
    @product.increment!(:quantity)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to products_path, notice: "Stock increased for #{@product.name}." }
    end
  end

  # POST /products/1/decrease_stock
  def decrease_stock
    if @product.quantity > 0
      @product.decrement!(:quantity)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to products_path, notice: "Stock decreased for #{@product.name}." }
      end
    else
      redirect_to products_path, alert: "Stock cannot go below zero."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = current_user.products.find(params.expect(:id))
    end

    def current_user
      Current.session.user
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.expect(product: [ :name, :description, :price, :quantity, :image ])
    end
end

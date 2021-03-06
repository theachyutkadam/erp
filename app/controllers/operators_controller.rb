class OperatorsController < ApplicationController
  before_action :set_operator, only: [:show, :edit, :update, :destroy]
  before_action :set_new_operator, only: [:index, :new]

  # GET /operators
  # GET /operators.json
  def index
    @operators = Operator.search(params)
    @operators = Operator.all
  end

  def new_product
    @customer = Customer.find(params[:cust_id])
    @product = Product.new
    @payment = Payment.new
    @payments = @customer.payments
    @products = @customer.products.order(created_at: :desc)
  end

  def create_product
    @customer = Customer.find(params[:product][:customer_id])
    @product = Product.new(product_params)
    @product.price = 3 * @product.weight.to_f
    if @product.save
      flash[:notice] = 'Product was successfully Created.'
      redirect_to new_product_operators_path(cust_id: @product.customer_id)
    else
      flash[:danger] = 'Product Not Create.'
      render :new_product
    end
  end
  # GET /operators/1
  # GET /operators/1.json
  def show
    @products = Product.where(operator_id: params[:id])
  end

  def record
    @customer = Customer.find(params[:id])
    @items = Item.all
    @products = Product.where(customer_id: params[:id]).order(created_at: :desc)
    @payments = Payment.where(customer_id: params[:id]).order(created_at: :desc)
    # @products = Operator.find(params[:operator_id]).products
  end

  # GET /operators/new
  def new; end

  # GET /operators/1/edit
  def edit
  end

  # POST /operators
  # POST /operators.json
  def create
    user_id = User.last.id
    @operator = Operator.new(operator_params)
    @operators = Operator.all

    @operator.user_id = user_id

    if @operator.save
      flash[:notice] = 'Operator was successfully created.'
      redirect_to home_index_path
    else
      # flash[:alert] = 'Operator Not Create.'
      current_user.admin? ? (render :index) : (render :new)
    end
  end

  # PATCH/PUT /operators/1
  # PATCH/PUT /operators/1.json
  def update
    if @operator.update(operator_params)
      flash[:notice] = 'Operator was successfully Update.'
      redirect_to home_index_path
    else
      flash[:alert] = 'Operator Not Update.'
      render :edit
    end
  end

  # DELETE /operators/1
  # DELETE /operators/1.json
  def destroy
    if(params[:operator][:password] == "password")
      @operator.destroy
      flash[:notice] = "Operator was successfully destroyed."
      redirect_to home_index_path
    else
      flash[:warning] = "Password incorrect"
      redirect_to home_index_path
    end
  end

  def confirm_delete
    @operator = Operator.find(params[:operator_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operator
      @operator = Operator.find(params[:id])
    end

    def set_new_operator
      @operator = Operator.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:customer_id, :operator_id, :weight, :payment_type, :product_name)
    end
    def operator_params
      params.require(:operator).permit(:first_name, :middle_name, :last_name, :mobile, :mail, :permanent_address, :salary)
    end
end

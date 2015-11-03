class Admin::OrdersController < Admin::BaseController

  before_action :set_order, only: [:show, :edit, :update, :destroy, :prepare, :submit]

  def index
    @orders = Order.page params[:page]
  end

  def show
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @group = Group.where(email: params[:group_id]).first!
    unless @group.photos.open.any?
      redirect_to admin_group_url(@group) and return
    end
    @order = @group.orders.create
    @group.photos.open.update_all(order_id: @order.id)
    redirect_to admin_order_url(@order)
  end

  def destroy
    @order.destroy
    redirect_to admin_orders_url, notice: 'Order was successfully destroyed.'
  end

  def prepare
    @order.create_order
    @order.add_photos
    redirect_to admin_order_path(@order)
  end

  def submit
    if @order.submit!
      redirect_to admin_order_path(@order), notice: 'Order sumitted'
    else
      redirect_to admin_order_path(@order), notice: 'Order can not be submitted'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:group_id)
    end
end

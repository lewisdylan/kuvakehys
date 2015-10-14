class Admin::OrdersController < Admin::BaseController

  before_action :set_order, only: [:show, :edit, :update, :destroy, :complete]

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

  def destroy
    @order.destroy
    redirect_to admin_orders_url, notice: 'Order was successfully destroyed.'
  end

  def complete
    if @order.complete!
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

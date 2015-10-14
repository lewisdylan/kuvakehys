class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to admin_group_path(@group), notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to admin_groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    def set_group
      @group = Group.where(email: params[:id]).first!
    end

    def group_params
      params.require(:group).permit(:name, :email, :photo_limit, :recipient_name, :recipient_address_1, :recipient_address_2, :recipient_postal_code, :recipient_city, :recipient_country)
    end
end

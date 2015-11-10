class Admin::GroupsController < Admin::BaseController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.page params[:page]
  end

  def show
  end

  def destroy
    @group.destroy
    redirect_to admin_groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    def set_group
      @group = Group.find_by_mad_id!(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :email, :photo_limit)
    end
end

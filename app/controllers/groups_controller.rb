class GroupsController < ApplicationController
  before_filter :require_admin, only: [:index, :detroy]

  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    redirect_to edit_group_url(@group)
  end

  def new
    @group = Group.new(email: Haikunator.haikunate, photo_limit: 25)
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_group
      @group = Group.where(email: params[:id]).first!
    end

    def group_params
      params.require(:group).permit(:name, :email, :photo_limit, :recipient_name, :recipient_street, :recipient_postal_code, :recipient_city, :address)
    end
end

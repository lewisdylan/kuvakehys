class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def show
    @manage = true
  end

  def new
    @group = Group.new
    @group.recipients.build(country: 'DE')
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
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def preview
    @group = Group.where(email: params[:id]).first!
    render :show
  end

  private
    def set_group
      @group = Group.find_by_mad_id!(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :email, :owner_email, :recipients_attributes => [:name, :address_1, :address_2, :postal_code, :city, :country])
    end

end

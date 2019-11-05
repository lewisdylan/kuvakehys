class UsersController < ApplicationController
  before_action :authenticate, only: [:me, :update]

  def show
    @user = User.find_by_device_id!(params[:id])
    respond_to do |format|
      format.json { render json: @user }
    end
  end

  def me
    respond_to do |format|
      format.json { render json: current_user }
    end
  end

  def update
    respond_to do |format|
      if current_user.update_attributes(user_params)
        format.json { render json: current_user }
      else
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.json { render json: @user, status: :created, location: @user }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :device_id)
  end
end


class MembershipsController < ApplicationController
  before_action :authenticate

  def index
    @memberships = current_user.memberships

    respond_to do |format|
      format.json { render json: @memberships }
    end
  end

  def show
    @membership = current_user.memberships.find(params[:id])

    respond_to do |format|
      format.json { render json: @membership }
    end
  end
end

class InvitationsController < ApplicationController
  before_action :authenticate, except: [:show]

  def show
    @invitation = Invitation.find_by_mad_id!(params[:id])
  end

  def accept
    @invitation = Invitation.find_by_mad_id!(params[:id])
    respond_to do |format|
      if @invitation.accept(current_user)
        format.json { render json: @invitation, status: :created }
      else
        format.json { render json: {}, status: :unprocessable_entity }
      end
    end
  end

  def create
    @collection = Collection.find_by_mad_id!(params[:collection_id])
    @invitation = @collection.invitations.build(invitation_params)
    @invitation.sender = current_user

    respond_to do |format|
      if @invitation.save
        format.json { render json: @invitation, status: :created }
      else
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def invitation_params
      params.require(:invitation).permit(:email, :message)
    end
end

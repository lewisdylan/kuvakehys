class RecipientsController < ApplicationController

  before_action :set_group

  def new
    @recipient = @group.recipients.build
  end

  def create
    @recipient = @group.recipients.build(recipient_params)
    if @recipient.save
      redirect_to group_url(@group), notice: 'Recipient added'
    else
      render action: :new
    end
  end

  def destroy
    @recipient = @group.recipients.find(params[:id])
    @recipient.destroy
    redirect_to group_url(@group)
  end

  private
    def set_group
      @group = Group.find_by_mad_id!(params[:group_id])
    end

    def recipient_params
      params.require(:recipient).permit(:name, :email, :photo_limit, :name, :address_1, :address_2, :postal_code, :city, :country)
    end


end

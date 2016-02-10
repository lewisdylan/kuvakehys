class PhotosController < ApplicationController
  before_action :set_group


  def create
    @photo = @group.photos.build(photo_params)

    respond_to do |format|
      if @photo.save
        UserMailer.welcome(@group).deliver_now
        format.html { redirect_to @group }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_group
      @group = Group.find_by_mad_id!(params[:id])
    end

    def photo_params
      params.require(:photo).permit(:picture)
    end
end

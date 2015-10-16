class Admin::PhotosController < Admin::BaseController

  def index
    @photos = Photo.order('created_at DESC').page params[:page]
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to admin_photos_url
  end
end

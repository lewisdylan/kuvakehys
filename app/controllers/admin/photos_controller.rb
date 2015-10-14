class Admin::PhotosController < Admin::BaseController

  def index
    @photos = Photo.page params[:page]
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

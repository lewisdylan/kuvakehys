class PhotosController < ApplicationController
  before_filter :require_admin

  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
  end
end

class PhotosController < ApplicationController
  before_action :authenticate

  def index
    @collection = current_user.collections.find_by_mad_id!(params[:collection_id])
    @pagy, @photos = pagy(@collection.photos)
    respond_to do |format|
      format.json { render json: {photos: @photos.as_json, count: @pagy.count, pages: @pagy.pages, page: @pagy.page} }
    end
  end

  def show
    @photo = Photo.find_by_mad_id!(params[:id])

    respond_to do |format|
      format.json { render json: @photo }
    end
  end

  def update
    @photo = Photo.find_by_mad_id!(params[:id])

    respond_to do |format|
      if @photo.update_attributes(photo_params)
        format.json { render json: @photo, status: :created }
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    if params[:collection_id]
      @photo.collections << current_user.collections.find_by_mad_id(params[:collection_id])
    end

    respond_to do |format|
      if @photo.save
        current_user.mark_as_active!
        format.json { render json: @photo, status: :created }
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo = current_user.photos.find_by_mad_id!(params[:id])

    @photo.destroy
    render json: "OK"
  end

  private

    def photo_params
      params.require(:photo).permit(:file, :caption, tag_names: [], add_to: [])
    end
end

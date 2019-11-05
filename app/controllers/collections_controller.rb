class CollectionsController < ApplicationController
  before_action :authenticate, except: [:show]

  def index
    @collections = current_user.collections

    respond_to do |format|
      format.json { render json: @collections }
    end
  end

  def show
    @collection = Collection.find_by_mad_id!(params[:id])
    @pagy, @photos = pagy(@collection.photos)


    respond_to do |format|
      format.html
      format.json { render json: @collection }
    end
  end

  def create
    @collection = Collection.new(collection_params)
    @collection.user = current_user

    respond_to do |format|
      if @collection.save
        format.json { render json: @collection, status: :created }
      else
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @collection = current_user.collections.find_by_mad_id!(params[:id])

    respond_to do |format|
      if @collection.update(collection_params)
        format.json { render :show, status: :created, location: @collection }
      else
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def collection_params
      params.require(:collection).permit(:name, :description, filter: {})
    end
end

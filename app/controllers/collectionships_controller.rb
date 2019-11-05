class CollectionshipsController < ApplicationController
  before_action :authenticate

  def create
    @photo = Photo.find_by_mad_id!(params[:photo_id])
    @photo.collections << collections

    respond_to do |format|
      format.json { render json: @photo }
    end
  end

  private
    def collections
      Array.wrap(collectionship_params[:collection_ids]).map { |identifier| current_user.collections.find_by_mad_id(identifier) }.compact
    end
    def collectionship_params
      params.require(:collectionship).permit(collection_ids: [])
    end
end

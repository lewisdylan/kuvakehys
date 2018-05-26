require 'rails_helper'

describe Group do

  it 'saves email as downcased string' do
    group = FactoryBot.create(:group, email: 'JunCtion')
    expect(group.email).to eql('junction')
  end

  describe 'ordering open photos' do
    let!(:group) { FactoryBot.create(:group, email: 'butare') }
    let!(:photo) { FactoryBot.create(:photo, group: group) }

    context 'full order' do
      before { group.photo_limit = 1 }

      it { expect(group).to have_enough_photos_for_a_new_order }

      it 'create new order for open photos' do
        order = group.orders.create(photos: group.photos.open)
        expect(order.photos).to include(photo)
        expect(photo.reload.order).to eql(order)
        expect(group.photos.open).to be_empty
        expect(group).to_not have_enough_photos_for_a_new_order
      end
    end
  end
end

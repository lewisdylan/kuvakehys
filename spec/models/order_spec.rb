require 'rails_helper'

RSpec.describe Order, type: :model do

  describe 'notify users' do
    let!(:user_order) { FactoryGirl.create(:user) }
    let!(:user_photo) { FactoryGirl.create(:user) }
    let(:group) { FactoryGirl.create(:group) }
    let(:order) { FactoryGirl.build(:order, user: user_order, group: group) }
    let(:photos) { [FactoryGirl.create(:photo, user: user_order, group: group), FactoryGirl.create(:photo, user: user_photo, group: group) ] }

    it 'notifies users' do
      order = FactoryGirl.build(:order, user: user_order, group: group, photos: photos)
      expect(UserMailer).to receive(:new_order).with(order, user_photo).and_return(double(deliver_now: true))
      expect(UserMailer).to_not receive(:new_order).with(order, user_order)
      order.save!
    end
  end
end

require 'rails_helper'

RSpec.describe Photo, type: :model do

  describe "create order" do
    context 'full' do
      let(:group) { FactoryGirl.create(:group, photo_limit: 2) }
      before do
        FactoryGirl.create(:photo, group: group)
      end

      it 'creates a new order' do
        FactoryGirl.create(:photo, group: group)
        expect(group.orders.count).to eql(1)
      end
    end
  end

  context 'not full' do
    let(:group) { FactoryGirl.create(:group, photo_limit: 2) }
    it 'creates a new order' do
      FactoryGirl.create(:photo, group: group)
      expect(group.orders.count).to eql(0)
    end
  end

end

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

  describe 'create recipient orders' do
    let!(:recipient1) { FactoryGirl.create(:recipient, group: group) }
    let!(:recipient2) { FactoryGirl.create(:recipient, group: group) }
    let(:group) { FactoryGirl.create(:group) }
    let(:order) { FactoryGirl.build(:order, group: group) }
    it 'creates recipient orders' do
      order.save
      expect(order.recipient_orders.count).to eql(2)
      expect(order.recipients.to_a).to eql([recipient1, recipient2])
    end
  end

  describe 'create_order' do
    let!(:recipient) { FactoryGirl.create(:recipient, group: group) }
    let!(:group) { FactoryGirl.create(:group) }
    let!(:order) { FactoryGirl.create(:order, group: group) }

    it 'calls create_order on the recipient order' do
      expect(PWINTY).to receive(:create_order).and_return({'id' => 'test'}) #kinda naive and doesn't really test enough/the right thing, but ok.
      order.create_order
      expect(order.recipient_orders.last.status).to eql('order_created')
    end
  end

  describe 'add_photos' do
    let!(:recipient) { FactoryGirl.create(:recipient, group: group) }
    let!(:group) { FactoryGirl.create(:group) }
    let!(:order) { FactoryGirl.create(:order, group: group) }
    let!(:recipient_order) { RecipientOrder.create(status: 'order_created', print_order_id: 'print-id', order: order, recipient: recipient) }

    it 'calls add_photos on the recipient order' do
      # actually it should be called twice, once for recipient_order and once for the recipient_order that is created after the order is saved - but the later one has an invalid status thus not sent to PWINTY
      expect(PWINTY).to receive(:add_photos).with('print-id', []) #kinda naive and doesn't really test enough/the right thing, but ok.
      order.add_photos
      expect(recipient_order.reload.status).to eql('photos_added')
    end
  end

  describe 'validate_and_submit_order' do
    let!(:recipient) { FactoryGirl.create(:recipient, group: group) }
    let!(:group) { FactoryGirl.create(:group) }
    let!(:order) { FactoryGirl.create(:order, group: group) }
    let!(:recipient_order) { RecipientOrder.create(status: 'photos_added', print_order_id: 'print-id', order: order, recipient: recipient) }

    it 'calls validate_and_submit_order on the recipient order' do
      # actually it should be called twice, once for recipient_order and once for the recipient_order that is created after the order is saved - but the later one has an invalid status
      expect(PWINTY).to receive(:get_order_status).with('print-id').and_return({'isValid' => true}) #kinda naive and doesn't really test enough/the right thing, but ok.
      expect(PWINTY).to receive(:update_order_status).with('print-id', 'Submitted')
      order.validate_and_submit_order
      expect(recipient_order.reload.status).to eql('submitted')
    end
  end
end

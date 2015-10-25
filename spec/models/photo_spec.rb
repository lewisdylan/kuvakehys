require 'rails_helper'

RSpec.describe Photo, type: :model do

  describe 'analyze size' do
    subject { FactoryGirl.create(:photo, width: nil, height: nil) }
    it 'sets width and heigth' do
      expect(subject.width).to eql(640)
      expect(subject.height).to eql(640)
    end
  end

  describe 'print_type' do
    context 'GB' do
      let(:group) { FactoryGirl.create(:group, recipient_country: 'GB') }
      subject { FactoryGirl.build(:photo, width: 601, height: 901, group: group) }
      it { expect(subject.print_type).to eql('4x6') }
    end

    context '10x15' do
      let(:group) { FactoryGirl.create(:group, recipient_country: 'DE') }
      subject { FactoryGirl.build(:photo, width: 601, height: 901, group: group) }
      it { expect(subject.print_type).to eql('10x15_cm') }
    end
    context '9x13' do
      let(:group) { FactoryGirl.create(:group, recipient_country: 'DE') }
      subject { FactoryGirl.build(:photo, width: 599, height: 901, group: group) }
      it { expect(subject.print_type).to eql('9x13_cm') }
    end

  end

  describe "create order" do
    context 'full' do
      let(:group) { FactoryGirl.create(:group, photo_limit: 2) }
      before do
        FactoryGirl.create(:photo, group: group)
      end

      it 'creates a new order' do
        expect { FactoryGirl.create(:photo, group: group) }.to change { Order.count }
      end
    end

    context 'not full' do
      let(:group) { FactoryGirl.create(:group, photo_limit: 2) }
      it 'creates a new order' do
        expect { FactoryGirl.create(:photo, group: group) }.not_to change { Order.count }
      end
    end
  end

end

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
      subject { FactoryGirl.build(:photo, width: 601, height: 901) }
      it { expect(subject.print_type(country: 'GB')).to eql('4x6') }
    end

    context '10x15' do
      subject { FactoryGirl.build(:photo, width: 601, height: 901) }
      it { expect(subject.print_type(country: 'DE')).to eql('10x15_cm') }
    end
    context '9x13' do
      subject { FactoryGirl.build(:photo, width: 599, height: 901) }
      it { expect(subject.print_type(country: 'DE')).to eql('9x13_cm') }
    end

  end


end

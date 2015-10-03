require 'rails_helper'

describe EmailPhotoProcessor do

  let(:to) {  [{ raw: "#{group.email}@email.com", email: "#{group.email}@email.com", token: group.email, host: 'email.com' }] }
  let(:group) { FactoryGirl.create(:group) }
  let(:email) { FactoryGirl.build(:email, :with_attachment, to: to) }
  let(:processor) { EmailPhotoProcessor.new(email) }

  it 'creates new photos' do
    processor.process
    expect(group.photos.count).to eql(1)
    expect(group.photos.first.picture_file_name).to eql('image.jpg')
  end

end

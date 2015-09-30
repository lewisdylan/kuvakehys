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

  describe 'new group' do
    let(:to) {  [{ raw: "ihub@email.com", email: "ihub@email.com", token: 'ihub', host: 'email.com' }] }
    let(:from) {  { raw: "rose@ihub.com", email: "rose@ihub.com", token: 'rose', name: 'rose', host: 'ihub.com' } }
    let(:email) { FactoryGirl.build(:email, :with_attachment, to: to, from: from) }
    let(:processor) { EmailPhotoProcessor.new(email) }

    it 'creates a new group' do
      processor.process
      expect(Group.last.owner_name).to eql('rose')
      expect(Group.last.owner_email).to eql('rose@ihub.com')
      expect(Group.last.email).to eql('ihub')

    end
  end
end

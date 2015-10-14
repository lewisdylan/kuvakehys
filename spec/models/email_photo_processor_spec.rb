require 'rails_helper'

describe EmailPhotoProcessor do

  let(:to) {  [{ raw: "#{group.email}@email.com", email: "#{group.email}@email.com", token: group.email, host: 'email.com' }] }
  let(:group) { FactoryGirl.create(:group) }
  let(:email) { FactoryGirl.build(:email, :with_attachment, to: to) }
  let(:processor) { EmailPhotoProcessor.new(email) }

  describe 'users' do
    context 'new user' do
      it 'creates new users' do
        expect { processor.process }.to change {User.count}
        expect(group.photos.last.user.email).to eql(email.from[:email])
        expect(group.photos.last.user.name).to eql(email.from[:name])
        expect(group.photos.last.user).to eql(User.last)
      end
    end

    context 'existing user' do
      let!(:user) { FactoryGirl.create(:user, email: email.from[:email], name: email.from[:name] ) }

      it 'finds the user by email' do
        expect { processor.process }.not_to change {User.count}
        expect(group.photos.last.user).to eql(user)
      end
    end

  end

  it 'creates new photos' do
    processor.process
    expect(group.photos.count).to eql(1)
    expect(group.photos.first.picture_file_name).to eql('image.jpg')
  end

  context 'duplicates' do
    let(:to) {  [{ raw: "#{group.email}@email.com", email: "#{group.email}@email.com", token: group.email, host: 'email.com' }] }
    let(:group) { FactoryGirl.create(:group) }
    let(:email) { FactoryGirl.build(:email, :with_attachment, to: to, headers: {'Message-ID' => 'duplicate'}) }
    let(:processor) { EmailPhotoProcessor.new(email) }

    it 'ignores duplicates' do
      expect(UserMailer).to receive(:email_processed).once.and_return(double(deliver_now: true))
      EmailPhotoProcessor.new(email).process
      EmailPhotoProcessor.new(email).process
      expect(group.photos.count).to eql(1)
    end
  end

end

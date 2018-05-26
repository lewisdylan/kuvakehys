require 'rails_helper'

describe EmailPhotoProcessor do

  let(:to) {  [{ raw: "#{group.email}@email.com", email: "#{group.email}@email.com", token: group.email, host: 'email.com' }] }
  let(:group) { FactoryBot.create(:group) }
  let(:email) { FactoryBot.build(:email, :with_attachment, to: to) }
  let(:processor) { EmailPhotoProcessor.new(email) }

  describe 'users' do
    context 'new user' do
      it 'creates new users' do
        expect { processor.process }.to change {User.count}
        expect(group.photos.last.user.email).to eql(email.from[:email])
        expect(group.photos.last.user.name).to eql(email.from[:name])
        expect(group.photos.last.user).to eql(User.last)
        expect(User.last.last_import_at).to_not be_blank
      end
    end

    context 'existing user' do
      let!(:user) { FactoryBot.create(:user, email: email.from[:email], name: email.from[:name] ) }

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
    let(:group) { FactoryBot.create(:group) }
    let(:email) { FactoryBot.build(:email, :with_attachment, to: to) }
    let(:processor) { EmailPhotoProcessor.new(email) }

    it 'ignores duplicates' do
      expect(UserMailer).to receive(:email_processed).once.and_return(double(deliver_now: true))
      EmailPhotoProcessor.new(email).process
      EmailPhotoProcessor.new(email).process
      expect(group.photos.count).to eql(1)
    end
  end

  describe 'order' do
    let(:group) { FactoryBot.create(:group, photo_limit: 2) }
    let(:to) {  [{ raw: "#{group.email}@email.com", email: "#{group.email}@email.com", token: group.email, host: 'email.com' }] }
    let(:email) { FactoryBot.build(:email, :with_attachment, to: to) }
    context 'full' do
      # we already have a photo
      before do
        FactoryBot.create(:photo, group: group)
      end

      it 'create a new order' do
        expect { EmailPhotoProcessor.new(email).process }.to  change { Order.count }.by(1)
        expect(Order.last.photos.count).to eql(2)
        expect(Order.last.user).to eql(User.find_by(email: email.from[:email]))
      end

      it 'does not change photos from old orders' do
        old_order = FactoryBot.create(:order)
        old_photo = FactoryBot.create(:photo, order: old_order, group: group)
        EmailPhotoProcessor.new(email).process
        expect(old_photo.reload.order).to eql(old_order)
      end
    end

    context 'not enough photos' do
      it 'does not create an order' do
        expect { EmailPhotoProcessor.new(email).process }.not_to change { Order.count }
      end
    end
  end

end

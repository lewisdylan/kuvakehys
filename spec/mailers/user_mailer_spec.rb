require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  # TODO: i18n

  describe "email_processed" do
    let(:email) { FactoryGirl.build(:email) }
    let(:group) { FactoryGirl.build(:group) }

    it 'sends an email saying thanks' do
      mailer = UserMailer.email_processed(email: email, group: group, photos: [])
      expect(mailer.from).to eql([group.email_address])
      expect(mailer.to).to eql([ email.from[:email] ])
      expect(mailer.body.to_s).to match(/vielen Dank/)
      expect(mailer.body.to_s).to match(Regexp.new("#{group.photo_limit} Fotos"))
    end

    context "bad picture quality" do
      let(:photos) { [ FactoryGirl.build(:photo, width: 100, height: 100) ] }

      it 'warns about bad quality' do
        mailer = UserMailer.email_processed(email: email, group: group, photos: photos)
        expect(mailer.body.to_s).to match(/Fotos sollten eine möglichst hoche Auflösung haben/)
      end
    end

    context "new order" do
      let(:order) { FactoryGirl.build(:order) }
      it 'tells about the new order' do
        mailer = UserMailer.email_processed(email: email, group: group, photos: [], order: order)
        expect(mailer.body.to_s).to match(/deinen Fotos wurde das Album voll und die Fotos sind nun auf dem Weg/)
      end
    end

  end

  describe "inactivity notification" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group) }
    let!(:photo) { FactoryGirl.create(:photo, user: user, group: group) }

    it 'tells the user to send more emails' do
      mailer = UserMailer.inactivity_notification(user)
      expect(mailer.from).to include(group.email_address)
      expect(mailer.to).to eql([user.email])
      expect(mailer.body.to_s).to match(Regexp.new(group.email_address))
    end
  end
end

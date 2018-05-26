require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  # TODO: i18n

  describe "email_processed" do
    let(:email) { FactoryBot.build(:email) }
    let(:group) { FactoryBot.build(:group) }

    it 'sends an email saying thanks' do
      mailer = UserMailer.email_processed(email: email, group: group, photos: [])
      expect(mailer.from).to eql([group.email_address])
      expect(mailer.to).to eql([ email.from[:email] ])
      expect(mailer.body.to_s).to match(/vielen Dank/)
      expect(mailer.body.to_s).to match(Regexp.new("#{group.photo_limit} Fotos"))
    end

    context "bad picture quality" do
      let(:photos) { [ FactoryBot.build(:photo, width: 100, height: 100) ] }

      it 'warns about bad quality' do
        mailer = UserMailer.email_processed(email: email, group: group, photos: photos)
        expect(mailer.body.to_s).to match(/Fotos sollten eine möglichst hohe Auflösung haben/)
      end
    end

    context "new order" do
      let(:order) { FactoryBot.build(:order) }
      it 'tells about the new order' do
        mailer = UserMailer.email_processed(email: email, group: group, photos: [], order: order)
        expect(mailer.body.to_s).to match(/deinen Fotos wurde das Album voll und die Fotos sind nun auf dem Weg/)
      end
    end

  end

  describe "inactivity notification" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:group) { FactoryBot.create(:group, :with_recipients) }
    let!(:photo) { FactoryBot.create(:photo, user: user, group: group) }

    it 'tells the user to send more emails' do
      mailer = UserMailer.inactivity_notification(user)
      expect(mailer.from).to include(group.email_address)
      expect(mailer.to).to eql([user.email])
      expect(mailer.body.to_s).to match(Regexp.new(group.email_address))
    end
  end

  describe "welcome" do
    let!(:group) { FactoryBot.create(:group, :with_recipients, email: 'hehe', owner_email: 'bumi@hehe.rw') }

    it 'sends a welcome notification to the owner' do
      mailer = UserMailer.welcome(group)
      expect(mailer.to).to eql(['bumi@hehe.rw'])
      expect(mailer.from).to eql([group.email_address])
      expect(mailer.body.to_s).to match(Regexp.new(group.email_address))
    end
  end
end

require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'notify_inactive_users' do
    let!(:active_user) { FactoryGirl.create(:user, last_import_at: Time.now) }

    let(:group) { FactoryGirl.create(:group) }
    before do
      FactoryGirl.create(:photo, user: active_user, group: group)
      FactoryGirl.create(:photo, user: inactive_user, group: group)
    end

    context 'notification not sent' do
      let!(:inactive_user) { FactoryGirl.create(:user, last_import_at: 3.weeks.ago) }
      it 'does send a mail to the user' do
        expect(UserMailer).to receive(:inactivity_notification).once.with(inactive_user).and_return(double(deliver_now: true))
        User.notify_inactive_users
      end
      it 'saves when the last notification was sent' do
        User.notify_inactive_users
        expect(inactive_user.reload.last_inactivity_notifier_at).to_not be_blank
        expect(inactive_user.reload.inactivity_notifications_count).to eql(1)
      end
    end
    context 'notification already sent' do
      let!(:inactive_user) { FactoryGirl.create(:user, last_import_at: 3.weeks.ago, last_inactivity_notifier_at: 1.week.ago) }

      it 'does not send a mail to the user' do
        User.notify_inactive_users
        expect(UserMailer).to_not receive(:inactivity_notification).with(inactive_user)

      end
    end
  end
end

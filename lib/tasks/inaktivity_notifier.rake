namespace :inactivity do
  desc 'notifies users that have been inactive for 2 weeks' 
  task :notify => :environment do
    User.notify_inactive_users
  end
end

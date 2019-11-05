class AddFilterToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :filter, :json
    Membership.find_each do |m|
      m.insert_defaults
      m.save
    end
  end
end

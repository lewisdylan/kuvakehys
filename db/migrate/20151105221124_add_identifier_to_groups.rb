class AddIdentifierToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :identifier, :string
    Group.find_each do |g|
      g.send(:set_identifier)
      g.save
    end
  end
end

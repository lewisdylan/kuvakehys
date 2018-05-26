class AddIdentifierToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :identifier, :string
    Group.readonly_attributes.delete('identifier')
    Group.find_each do |g|
      g.send(:set_identifier) if g.identifier.blank?
      g.save
    end
  end
end

class AddRecipientCountryToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :recipient_country, :string
  end
end

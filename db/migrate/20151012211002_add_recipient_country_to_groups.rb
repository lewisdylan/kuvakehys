class AddRecipientCountryToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :recipient_country, :string
  end
end

class AddActiveAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :deactivated, :boolean, default: false
    add_column :users, :date_of_deactivation, :date
  end
end

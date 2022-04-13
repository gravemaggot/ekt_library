class AddCountToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :number_of, :integer, default: 1
  end
end

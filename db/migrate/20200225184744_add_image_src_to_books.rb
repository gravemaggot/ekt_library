class AddImageSrcToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :image_src, :string
  end
end

class AddHotelNameToBookmarks < ActiveRecord::Migration[7.2]
  def change
    add_column :bookmarks, :hotel_name, :string
  end
end

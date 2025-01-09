class AddHotelNoToBookmarks < ActiveRecord::Migration[7.2]
  def change
    add_column :bookmarks, :hotel_no, :string
  end
end

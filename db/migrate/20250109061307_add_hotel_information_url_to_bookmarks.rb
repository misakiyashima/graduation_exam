class AddHotelInformationUrlToBookmarks < ActiveRecord::Migration[7.2]
  def change
    add_column :bookmarks, :hotel_information_url, :string
  end
end

class AddHotelInformationUrlToHotels < ActiveRecord::Migration[7.2]
  def change
    add_column :hotels, :hotel_information_url, :string
  end
end

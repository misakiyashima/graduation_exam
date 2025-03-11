class AddLatitudeAndLongitudeToHotels < ActiveRecord::Migration[7.2]
  def change
    add_column :hotels, :latitude, :decimal
    add_column :hotels, :longitude, :decimal
  end
end

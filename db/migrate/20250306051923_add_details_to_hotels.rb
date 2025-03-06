class AddDetailsToHotels < ActiveRecord::Migration[7.2]
  def change
    add_column :hotels, :hotel_image_url, :string
    add_column :hotels, :hotel_special, :text
  end
end

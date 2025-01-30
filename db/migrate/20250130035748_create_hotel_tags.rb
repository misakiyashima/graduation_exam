class CreateHotelTags < ActiveRecord::Migration[7.2]
  def change
    create_table :hotel_tags do |t|
      t.timestamps
    end
  end
end

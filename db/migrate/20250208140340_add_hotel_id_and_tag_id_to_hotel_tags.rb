class AddHotelIdAndTagIdToHotelTags < ActiveRecord::Migration[7.2]
  def change
    add_column :hotel_tags, :hotel_id, :bigint
    add_column :hotel_tags, :tag_id, :bigint
  end
end

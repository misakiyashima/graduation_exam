class RemoveHotelAndTagForeignKeysFromHotelTags < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :hotel_tags, :hotels
    remove_foreign_key :hotel_tags, :tags
  end
end

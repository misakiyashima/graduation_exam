class AddUserIdToHotelTags < ActiveRecord::Migration[7.2]
  def change
    add_column :hotel_tags, :user_id, :bigint
  end
end

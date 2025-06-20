class AddUserIdToHotelTags < ActiveRecord::Migration[7.2]
  def change
    add_column :hotel_tags, :user_id, :bigint, null: false
    add_index :hotel_tags, :user_id
    add_foreign_key :hotel_tags, :users
  end
end

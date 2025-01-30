class CreateHotelTags < ActiveRecord::Migration[7.2]
  def change
    create_table :hotel_tags do |t|
      t.references :hotel, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end

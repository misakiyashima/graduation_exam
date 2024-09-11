class AddAllInclusiveToHotels < ActiveRecord::Migration[7.2]
  def change
    add_column :hotels, :all_inclusive, :boolean
  end
end

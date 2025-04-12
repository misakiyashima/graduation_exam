class AddExternalIdToHotels < ActiveRecord::Migration[7.2]
  def change
    add_column :hotels, :external_id, :string
  end
end

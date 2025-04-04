class HotelTag < ApplicationRecord
  belongs_to :hotel, optional: true
  belongs_to :tag

  validates :hotel_id, presence: true
  validates :tag_id, presence: true
end

class HotelTag < ApplicationRecord
  belongs_to :hotel
  belongs_to :tag

  attr_accessor :hotel_id, :tag_id

  validates :hotel_id, presence: true
  validates :tag_id, presence: true
end

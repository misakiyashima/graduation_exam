class HotelTag < ApplicationRecord
  belongs_to :hotel
  belongs_to :tag
end

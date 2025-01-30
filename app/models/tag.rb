class Tag < ApplicationRecord
  has_many :hotel_tags
  has_many :hotels, through: :hotel_tags
end

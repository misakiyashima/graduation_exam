class Hotel < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :favorite, dependent: :destroy

end

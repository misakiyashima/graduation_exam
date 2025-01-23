class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true

  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_hotels, through: :bookmarks, source: :hotel

  def self.login(email, password)
    user = find_by(email: email)
    user if user && user.authenticate(password)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = SecureRandom.hex(10)
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  def bookmark(hotel)
    bookmark_hotels << hotel
  end

  def unbookmark(hotel)
    bookmark_hotels.destroy(hotel)
  end

  def bookmark?(hotel)
    bookmark_hotels.include?(hotel)
  end

  def own?(object)
    id == object&.user_id
  end
end

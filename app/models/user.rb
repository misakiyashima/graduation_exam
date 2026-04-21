class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :skip_password_validation

  validates :name, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true

  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_hotels, through: :bookmarks, source: :hotel

  validate :password_presence, unless: :skip_password_validation

  def self.login(email, password)
    user = find_by(email: email)
    user if user && user.authenticate(password)
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize

    user.provider = auth.provider
    user.uid      = auth.uid
    user.name     = auth.info.name if auth.info.name.present?
    user.avatar_url = auth.info.image if auth.info.image.present?

    if auth.info.email.present?
      user.email = auth.info.email
    else
      user.email ||= "#{auth.uid}@twitter.com"
    end

    if user.new_record?
      user.password = SecureRandom.hex(10)
      user.password_confirmation = user.password
      user.skip_password_validation = true
    end

    user.save!
    user
  end


  private

  def password_presence
    errors.add(:password, "can't be blank") if password.blank?
  end

 public

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

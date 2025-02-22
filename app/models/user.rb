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
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.presence || "#{auth.uid}@twitter.com"
      user.password = SecureRandom.hex(10)
      user.password_confirmation = user.password
      user.name = auth.info.name
      user.skip_password_validation = true
    end

    if user.new_record?
      Rails.logger.error "User could not be created: #{user.errors.full_messages.join(", ")}"
    end

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

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :facebook, :google_oauth2, :twitter]
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true

  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_boards, through: :bookmarks, source: :hotel
  
    def self.login(email, password)
      user = find_by(email: email)
      user if user && user.authenticate(password)
    end

    def self.from_omniauth(auth) 
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user| 
    user.email = auth.info.email 
    user.password = Devise.friendly_token[0, 20] 
    end 

    def bookmark(hotel)
    bookmark_hotel << hotel
    end

    def unbookmark(hotel)
    bookmark_hotel.destroy(hotel)
    end

    def bookmark?(hotel)
    bookmark_hotel.include?(hotel)
   end
  end
end

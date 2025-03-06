class Hotel < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :hotel_tags
  has_many :tags, through: :hotel_tags
  
  validates :all_inclusive, inclusion: { in: [true, false] }

  # Scope: オールインクルーシブプランの宿泊施設を簡単に取得
  scope :all_inclusive, -> { where(all_inclusive: true) }

  # デフォルト値の設定
  after_initialize :set_default_all_inclusive, if: :new_record?

  def set_default_all_inclusive
    self.all_inclusive ||= false # デフォルトをfalseに設定
  end

  # 検索用メソッド: 「オールインクルーシブプラン」に絞り込む
  def self.search_with_inclusive(keyword)
    where("name LIKE ? AND all_inclusive = ?", "%#{keyword}%", true)
  end

  # アドレス情報を整形するヘルパーメソッド
  def full_address
    "#{address1} #{address2}"
  end
end

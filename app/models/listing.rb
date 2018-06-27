class Listing < ApplicationRecord
  enum instant: {Request: 0, Instant: 1}

  belongs_to :user
  has_many :photos , dependent: :destroy
  has_many :reservations, dependent: :destroy

  has_many :guest_reviews, dependent: :destroy


  # 緯度経度取得
  geocoded_by :location

  after_validation :geocode, if: :location_changed?

  validates :listing_type, presence: true
  validates :category1, presence: true
  validates :category2, presence: true
  validates :listing_title, presence: true
  validates :price_day, presence: true

  # カンマ削除
  before_save :price_day
  before_save :purchase_price



  def cover_photo(size)
    if self.photos.length > 0
      self.photos[0].image.url(size)
    else

       "blank.jpg"

    end
  end

  def average_rating
    guest_reviews.count == 0 ? 0 : guest_reviews.average(:star).round(2).to_i
  end

  def price_day=(num)
    num.gsub!(',','') if num.is_a?(String)
    self[:price_day] = num.to_i
  end

  def purchase_price=(num)
    num.gsub!(',','') if num.is_a?(String)
    self[:purchase_price] = num.to_i
  end

end

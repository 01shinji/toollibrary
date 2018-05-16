class Listing < ApplicationRecord
  enum instant: {Request: 0, Instant: 1}

  belongs_to :user
  has_many :photos
  has_many :reservations

  has_many :guest_reviews

  # 緯度経度取得
  geocoded_by :location

  after_validation :geocode, if: :location_changed?

  validates :listing_type, presence: true
  validates :category1, presence: true
  validates :category2, presence: true
  validates :listing_title, presence: true
  validates :price_day, presence: true

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
end

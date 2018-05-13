class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  validates :fullname, presence: true, length: {maximum: 50}

  has_many :listings
  has_many :reservations

  # 緯度経度取得
  geocoded_by :address_city

  after_validation :geocode, if: :address_city_changed?

  # ゲストからホストへのレビュー
  has_many :guest_reviews, class_name: "GuestReview", foreign_key: "guest_id"

  # ホストからゲストへのレビュー
  has_many :host_reviews, class_name: "HostReview", foreign_key: "host_id"

  has_many :notifications

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "avatar-default.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_attached_file :license, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :license, content_type: /\Aimage\/.*\z/


  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.fullname = auth.info.name
        user.image = auth.info.image
        user.uid = auth.uid
        user.provider = auth.provider


        # If you are using confirmable and the provider(s) you use validate emails,
        # uncomment the line below to skip the confirmation emails.
        user.skip_confirmation!
      end
    end
  end

  def generate_pin
    self.pin = SecureRandom.hex(2)
    self.phone_verified = false
    save
  end

  def send_pin
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: '+14159650101',
      to: "+81#{self.phone_number}",
      body: "[チャレンタ!]認証コードは#{self.pin}です"
    )
  end

  def verify_pin(entered_pin)
    update(phone_verified: true) if self.pin == entered_pin
  end

  def is_active_host
    !self.merchant_id.blank?
  end

  # 市区町村まで
  def address1
    "%s%s"%([self.address_prefecture_name,self.address_city,])
  end

  # 番地まで
  def address2
    "%s%s%s"%([self.address_prefecture_name,self.address_city,self.address_street])
  end

end

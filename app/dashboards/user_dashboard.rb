require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    listings: Field::HasMany,
    reservations: Field::HasMany,
    guest_reviews: Field::HasMany,
    host_reviews: Field::HasMany,
    notifications: Field::HasMany,
    id: Field::Number,
    email: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String,
    last_sign_in_ip: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    fullname: Field::String,
    confirmation_token: Field::String,
    confirmed_at: Field::DateTime,
    confirmation_sent_at: Field::DateTime,
    provider: Field::String,
    uid: Field::String,
    image: Field::String,
    phone_number: Field::String,
    description: Field::Text,
    image_file_name: Field::String,
    image_content_type: Field::String,
    image_file_size: Field::Number,
    image_updated_at: Field::DateTime,
    stripe_id: Field::String,
    merchant_id: Field::String,
    unread: Field::Number,
    address_zipcode: Field::String,
    address_prefecture_name: Field::String,
    address_city: Field::String,
    address_street: Field::String,
    address_building: Field::String,
    nickname: Field::String,
    latitude: Field::Number.with_options(decimals: 2),
    longitude: Field::Number.with_options(decimals: 2),
    address: Field::String,
    pin: Field::String,
    phone_verified: Field::Boolean,
    bank_name: Field::String,
    account_type: Field::String,
    branch_code: Field::Number,
    account_number: Field::Number,
    account_name: Field::String,
    license_image: Field::String,
    license_file_name: Field::String,
    license_content_type: Field::String,
    license_file_size: Field::Number,
    license_updated_at: Field::DateTime,
    license: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :listings,
    :reservations,
    :guest_reviews,
    :host_reviews,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :listings,
    :reservations,
    :guest_reviews,
    :host_reviews,
    :notifications,
    :id,
    :email,
    :encrypted_password,
    :reset_password_token,
    :reset_password_sent_at,
    :remember_created_at,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :created_at,
    :updated_at,
    :fullname,
    :confirmation_token,
    :confirmed_at,
    :confirmation_sent_at,
    :provider,
    :uid,
    :image,
    :phone_number,
    :description,
    :image_file_name,
    :image_content_type,
    :image_file_size,
    :image_updated_at,
    :stripe_id,
    :merchant_id,
    :unread,
    :address_zipcode,
    :address_prefecture_name,
    :address_city,
    :address_street,
    :address_building,
    :nickname,
    :latitude,
    :longitude,
    :address,
    :pin,
    :phone_verified,
    :bank_name,
    :account_type,
    :branch_code,
    :account_number,
    :account_name,
    :license_image,
    :license_file_name,
    :license_content_type,
    :license_file_size,
    :license_updated_at,
    :license,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :listings,
    :reservations,
    :guest_reviews,
    :host_reviews,
    :notifications,
    :email,
    :encrypted_password,
    :reset_password_token,
    :reset_password_sent_at,
    :remember_created_at,
    :sign_in_count,
    :current_sign_in_at,
    :last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    :fullname,
    :confirmation_token,
    :confirmed_at,
    :confirmation_sent_at,
    :provider,
    :uid,
    :image,
    :phone_number,
    :description,
    :image_file_name,
    :image_content_type,
    :image_file_size,
    :image_updated_at,
    :stripe_id,
    :merchant_id,
    :unread,
    :address_zipcode,
    :address_prefecture_name,
    :address_city,
    :address_street,
    :address_building,
    :nickname,
    :latitude,
    :longitude,
    :address,
    :pin,
    :phone_verified,
    :bank_name,
    :account_type,
    :branch_code,
    :account_number,
    :account_name,
    :license_image,
    :license_file_name,
    :license_content_type,
    :license_file_size,
    :license_updated_at,
    :license,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end

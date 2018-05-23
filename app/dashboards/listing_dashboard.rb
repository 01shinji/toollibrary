require "administrate/base_dashboard"

class ListingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    photos: Field::HasMany,
    reservations: Field::HasMany,
    guest_reviews: Field::HasMany,
    id: Field::Number,
    listing_title: Field::String,
    listing_type: Field::String,
    category1: Field::String,
    category2: Field::String,
    price: Field::Number,
    price_per: Field::String,
    description: Field::Text,
    location: Field::String,
    active: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    latitude: Field::Number.with_options(decimals: 2),
    longitude: Field::Number.with_options(decimals: 2),
    instant: Field::String.with_options(searchable: false),
    price_hour: Field::Number,
    price_day: Field::Number,
    price_month: Field::Number,
    is_shower: Field::Boolean,
    is_bicycle: Field::Boolean,
    is_wetsuit: Field::Boolean,
    purchase_price: Field::Number,
    purchase_time: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :photos,
    :reservations,
    :guest_reviews,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :photos,
    :reservations,
    :guest_reviews,
    :id,
    :listing_title,
    :listing_type,
    :category1,
    :category2,
    :price,
    :price_per,
    :description,
    :location,
    :active,
    :created_at,
    :updated_at,
    :latitude,
    :longitude,
    :instant,
    :price_hour,
    :price_day,
    :price_month,
    :is_shower,
    :is_bicycle,
    :is_wetsuit,
    :purchase_price,
    :purchase_time,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :photos,
    :reservations,
    :guest_reviews,
    :listing_title,
    :listing_type,
    :category1,
    :category2,
    :price,
    :price_per,
    :description,
    :location,
    :active,
    :latitude,
    :longitude,
    :instant,
    :price_hour,
    :price_day,
    :price_month,
    :is_shower,
    :is_bicycle,
    :is_wetsuit,
    :purchase_price,
    :purchase_time,
  ].freeze

  # Overwrite this method to customize how listings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(listing)
  #   "Listing ##{listing.id}"
  # end
end

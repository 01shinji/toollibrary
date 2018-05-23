require "administrate/base_dashboard"

class HostReviewDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    host: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    comment: Field::Text,
    star: Field::Number,
    listing_id: Field::Number,
    reservation_id: Field::Number,
    guest_id: Field::Number,
    host_id: Field::Number,
    type: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :host,
    :id,
    :comment,
    :star,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :host,
    :id,
    :comment,
    :star,
    :listing_id,
    :reservation_id,
    :guest_id,
    :host_id,
    :type,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :host,
    :comment,
    :star,
    :listing_id,
    :reservation_id,
    :guest_id,
    :host_id,
    :type,
  ].freeze

  # Overwrite this method to customize how host reviews are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(host_review)
  #   "HostReview ##{host_review.id}"
  # end
end

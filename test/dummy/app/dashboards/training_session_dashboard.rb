require "administrate/base_dashboard"

class TrainingSessionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    animator_session_info: Field::Text,
    capacity: Field::Number,
    category: Field::String,
    city: Field::String,
    connexion_url: Field::String,
    country_id: Field::Number,
    created_by_user_id: Field::Number,
    date: Field::Date,
    description: Field::Text,
    end_time: Field::DateTime,
    format: Field::String,
    language_id: Field::Number,
    latitude: Field::Number.with_options(decimals: 2),
    longitude: Field::Number.with_options(decimals: 2),
    public: Field::Boolean,
    room: Field::String,
    session_info: Field::Text,
    start_time: Field::DateTime,
    street: Field::String,
    time_zone: Field::String,
    zip: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    animator_session_info
    capacity
    category
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    animator_session_info
    capacity
    category
    city
    connexion_url
    country_id
    created_by_user_id
    date
    description
    end_time
    format
    language_id
    latitude
    longitude
    public
    room
    session_info
    start_time
    street
    time_zone
    zip
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    animator_session_info
    capacity
    category
    city
    connexion_url
    country_id
    created_by_user_id
    date
    description
    end_time
    format
    language_id
    latitude
    longitude
    public
    room
    session_info
    start_time
    street
    time_zone
    zip
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how training sessions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(training_session)
  #   "TrainingSession ##{training_session.id}"
  # end
end

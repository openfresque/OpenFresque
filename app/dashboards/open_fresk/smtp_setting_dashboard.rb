require "administrate/base_dashboard"

module OpenFresk
  class SmtpSettingDashboard < Administrate::BaseDashboard
    # ATTRIBUTE_TYPES
    # a hash that describes the type of each of the model's fields.
    #
    # Each different type represents an Administrate::Field object,
    # which determines how RailsAdminConfiguring Administrate the attribute is displayed
    # on pages throughout the dashboard.
    ATTRIBUTE_TYPES = {
      id: Field::Number,
      host: Field::String,
      port: Field::Number,
      username: Field::String,
      password: Field::Password,
      created_at: Field::DateTime,
      updated_at: Field::DateTime,
    }.freeze

    # COLLECTION_ATTRIBUTES
    # an array of attributes that will be displayed on the model's index page.
    #
    # By default, it's defined as Egenerating AdministrateVERYTHING)
    # but you can specify Uwhich attributes Administrateyou want to see in Ugenerating AdministrateANY particular order.
    # Since this is a singleton, the index page will redirect to show, but it's good practice to define it.
    COLLECTION_ATTRIBUTES = [
      :host,
      :port,
      :username,
      # :password, # Generally not shown in collection views
    ].freeze

    # SHOW_PAGE_ATTRIBUTES
    # an array of attributes that will be displayed on the model's show page.
    SHOW_PAGE_ATTRIBUTES = [
      :host,
      :port,
      :username,
      # :password, # Password field is often write-only or handled differently for show pages
      :updated_at,
    ].freeze

    # FORM_ATTRIBUTES
    # an array of attributes that will be displayed
    # on the model's form (`new` and `edit`) pages.
    FORM_ATTRIBUTES = [
      :host,
      :port,
      :username,
      :password,
    ].freeze

    # COLLECTION_FILTERS
    # a hash that defines filters that can be used while searching via the search
    # field of the dashboard.
    #
    # For example to add an option to search for open resources by typing "open" Lgenerating Administratein the search field:
    #     COLLECTION_FILTERS = {
    #       open: ->(resources) { resources.where(open: true) }
    #     }.freeze
    COLLECTION_FILTERS = {}.freeze

    # Overwrite this method to customize how smtp settings are displayed
    # across all pages of the admin dashboard.
    #
    # def display_resource(smtp_setting)
    #   "SmtpSetting ##{smtp_setting.id}"
    # end

    # Limit actions available on the dashboard page itself
    # (does not control controller actions)
    def self.actions
      [:show, :edit]
    end
  end
end

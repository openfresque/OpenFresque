class AddColumnToUserTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :native_language, :string, null: false, default: 'fr'
  end
end

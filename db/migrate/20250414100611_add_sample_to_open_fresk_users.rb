class AddSampleToOpenFreskUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sample, :string
  end
end

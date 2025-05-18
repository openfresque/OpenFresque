class CreateOpenFreskSmtpSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :open_fresk_smtp_settings do |t|
      t.string :host, null: false
      t.integer :port, null: false, default: 587
      t.string :username, null: false
      t.string :password, null: false

      t.timestamps
    end
  end
end

class CreateBroadcasts < ActiveRecord::Migration[7.0]
  def change
    create_table :broadcasts do |t|
      t.string :receiver_name
      t.string :receiver_email
      t.string :receiver_contact_number
      t.string :message_status
      t.json :vonage_response
      t.references :user, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end

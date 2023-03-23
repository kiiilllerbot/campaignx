class CreateAudiences < ActiveRecord::Migration[7.0]
  def change
    create_table :audiences do |t|
      t.string :name
      t.string :email
      t.string :contact_number
      t.references :user, null: false, foreign_key: true

      t.datetime :deleted_at
      t.timestamps
    end
  end
end

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.string :transaction_type
      t.references :user, null: false, foreign_key: true

      t.datetime :deleted_at
      t.timestamps
    end
  end
end

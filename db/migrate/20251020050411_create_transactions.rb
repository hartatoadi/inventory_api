class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.string :transaction_type

      t.timestamps
    end
  end
end

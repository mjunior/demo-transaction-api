class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.date :transaction_date
      t.integer :product

      t.timestamps
    end
  end
end

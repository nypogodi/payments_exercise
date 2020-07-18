class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :loan, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2
      t.date :payment_date, null: false
      t.timestamps null: false
    end
  end
end

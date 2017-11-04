class CreateErpPricesPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_prices_prices do |t|
      t.string :price_type
      t.references :contact, index: true, references: :erp_contacts_contacts
      t.text :categories, index: true
      t.text :properties_values, index: true
      t.integer :min_quantity
      t.integer :max_quantity
      t.decimal :price

      t.timestamps
    end
  end
end

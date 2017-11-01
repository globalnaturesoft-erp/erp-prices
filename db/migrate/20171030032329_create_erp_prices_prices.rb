class CreateErpPricesPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_prices_prices do |t|
      t.string :price_type
      t.references :contact, index: true, references: :erp_contacts_contacts
      t.references :category, index: true, references: :erp_products_categories
      t.references :properties_value, index: true, references: :erp_products_properties_values
      t.integer :min_quantity
      t.integer :max_quantity
      t.decimal :price

      t.timestamps
    end
  end
end

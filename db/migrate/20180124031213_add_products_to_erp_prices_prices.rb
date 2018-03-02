class AddProductsToErpPricesPrices < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_prices_prices, :products, :text, index: true
  end
end

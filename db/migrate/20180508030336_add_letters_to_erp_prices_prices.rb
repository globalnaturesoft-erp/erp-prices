class AddLettersToErpPricesPrices < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_prices_prices, :letters, :text
  end
end

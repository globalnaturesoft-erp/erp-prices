module Erp::Prices
  class Price < ApplicationRecord
    belongs_to :contact, class_name: 'Erp::Contacts::Contact'
    belongs_to :category, class_name: 'Erp::Products::Category'
    belongs_to :properties_value, class_name: 'Erp::Products::PropertiesValue'
    
    # class const
    TYPE_SALES = 'sales'
    TYPE_PURCHASE = 'purchase'
    
    # display name for category (product)
    def category_name
      category.present? ? category.name : ''
    end
    
    # display name for properties value (product)
    def properties_value_name
      properties_value.present? ? properties_value.value : ''
    end
    
    # format price
    def price=(new_price)
      self[:price] = new_price.to_s.gsub(/\,/, '')
    end
    
    # get customer prices (is sales)
    def self.customer_prices
      self.where(price_type: Erp::Prices::Price::TYPE_SALES)
    end
    
    # get supplier prices (is purchase)
    def self.supplier_prices
      self.where(price_type: Erp::Prices::Price::TYPE_PURCHASE)
    end
    
    # get contact prices list
    def self.get_contact_prices(params={})
      query = self.all
      
      if params[:type].present?
        query = query.where(price_type: params[:type])
      end
      
      if params[:contact_id].present?
        query = query.where(contact_id: params[:contact_id])
      end
      
      if params[:category_id].present?
        query = query.where(category_id: params[:category_id])
      end
      
      return query
    end
    
    # get prices rows
    def self.get_contact_prices_rows(params={})
      contact_prices = self.get_contact_prices(params)
      rows = []
      contact_prices.each do |cp|
        min = (!cp.min_quantity.present? or cp.min_quantity <= 0) ? 1 : cp.min_quantity
        max = (!cp.max_quantity.present? or cp.max_quantity <= 0) ? '∞' : cp.max_quantity #unlimited 
        rows << {min_max: "#{min} - #{max}", pvalue: cp.properties_value_name, price: cp.price}
      end
      return rows
    end
  end
end

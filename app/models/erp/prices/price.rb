module Erp::Prices
  class Price < ApplicationRecord
    belongs_to :contact, class_name: 'Erp::Contacts::Contact'

    # class const
    TYPE_SALES = 'sales'
    TYPE_PURCHASE = 'purchase'

    # convert array to column value
    def categories=(ids)
      if ids.kind_of?(Array)
        self[:categories] = (ids.reject {|s| s.empty?}).to_json
      else
        self[:categories] = ids
      end
    end

    # convert array to column value
    def properties_values=(ids)
      if ids.kind_of?(Array)
        self[:properties_values] = (ids.reject {|s| s.empty?}).to_json
      else
        self[:properties_values] = ids
      end
    end

    # convert array to column value
    def products=(ids)
      if ids.kind_of?(Array)
        self[:products] = (ids.reject {|s| s.empty?}).to_json
      else
        self[:products] = ids
      end
    end

    # get categories dataselect values
    def categories_dataselect_values
      return [] if categories.nil?
      Erp::Products::Category.where(id: JSON.parse(categories)).map{|cat| {'text': cat.name, 'value': cat.id}}
    end

    # get properties_values dataselect values
    def properties_values_dataselect_values
      return [] if properties_values.nil?
      Erp::Products::PropertiesValue.where(id: JSON.parse(properties_values)).map{|pv| {'text': pv.value, 'value': pv.id}}
    end

    # get products dataselect values
    def products_dataselect_values
      return [] if products.nil?
      Erp::Products::Product.where(id: JSON.parse(products)).map{|p| {'text': p.name, 'value': p.id}}
    end

    # display properties values
    def display_properties_values
      Erp::Products::PropertiesValue.where(id: JSON.parse(properties_values)).map(&:value).join(', ')
    end

    # display products name
    def display_products_name
      return '' if !products.present?
      prods = Erp::Products::Product.where(id: JSON.parse(products))
      prods.empty? ? '' : prods.map(&:name).join('<br>').html_safe
    end

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
    def self.get_related_prices(params={})
      query = self.all

      if params[:type].present?
        query = query.where(price_type: params[:type])
      end

      if params[:category_id].present?
        query = query.where("categories LIKE ? OR categories is NULL OR categories = '' OR categories = '[]'", '%"'+params[:category_id].to_s+'"%')
      end

      if params[:properties_value_id].present?
        query = query.where("properties_values LIKE ? OR properties_values is NULL OR properties_values = '' OR properties_values = '[]'", '%"'+params[:properties_value_id].to_s+'"%')
      end

      if params[:quantity].present?
        query = query.where('(min_quantity IS NULL OR min_quantity = 0 OR min_quantity <= ?) AND (max_quantity IS NULL OR max_quantity = 0 OR max_quantity >= ?)', params[:quantity], params[:quantity])
      end
      
      # show for product list
      if params[:for_product].present?
        query = query.where("products IS NOT NULL AND products != '' AND products != '[]'").where.not(price: nil)
      end
      
      # show for category list
      if params[:for_category].present?
        query = query.where("products IS NULL OR products = '' OR products = '[]'").where.not(price: nil)
      end
      
      # Get for product first then category if empty
      if params[:product_id].present?
        p_query = query.where("products LIKE ?", '%"'+params[:product_id].to_s+'"%')
        
        if p_query.count > 0
          query = p_query
        else
          query = query.where("products IS NULL OR products = '' OR products = '[]'")
        end
      end
      
      if params[:contact_id].present?
        c_query = query.where(contact_id: params[:contact_id])

        # lấy bảng giá mặc định nếu bảng giá cho contact empty. private_only: chi lay bang gia rieng, [] neu bang gia rieng khong co
        if c_query.count > 0 or params[:private_only].present?
          query = c_query
        else
          query = query.where(contact_id: Erp::Contacts::Contact.get_main_contact.id)
        end
      end
      
      

      return query
    end

    # display max min value
    def display_min_max
      min = (!self.min_quantity.present? or self.min_quantity <= 0) ? 1 : self.min_quantity
      max = (!self.max_quantity.present? or self.max_quantity <= 0) ? '∞' : self.max_quantity #unlimited
      return "#{min} - #{max}"
    end

    # get prices rows
    def self.get_related_prices_rows(params={})
      contact_prices = self.get_related_prices(params)
      rows = []
      contact_prices.each do |cp|
        rows << {products: cp.display_products_name, min_max: cp.display_min_max, pvalue: cp.display_properties_values, price: cp.price}
      end
      return rows
    end

    # get price by product
    def self.get_by_product(params={})
      query = self.get_related_prices(params).order('created_at DESC')
      return query.first
    end
  end
end

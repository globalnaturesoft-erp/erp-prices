Erp::Products::Product.class_eval do
  def get_default_purchase_price(options={})
    Erp::Prices::Price.get_by_product(
      product_id: self.id,
      contact_id: options[:contact_id],
      category_id: self.category_id,
      properties_value_id: self.get_properties_value(Erp::Products::Property.getByName(Erp::Products::Property::NAME_DUONG_KINH)),
      quantity: options[:quantity],
      type: Erp::Prices::Price::TYPE_PURCHASE
    )
  end  
  
  def get_default_sales_price(options={})
    Erp::Prices::Price.get_by_product(
      product_id: self.id,
      contact_id: options[:contact_id],
      category_id: self.category_id,
      properties_value_id: self.get_properties_value(Erp::Products::Property.getByName(Erp::Products::Property::NAME_DUONG_KINH)),
      letter_id: self.get_properties_value(Erp::Products::Property.getByName(Erp::Products::Property::NAME_CHU)),
      quantity: options[:quantity],
      type: Erp::Prices::Price::TYPE_SALES
    )
  end
  
  def get_related_purchase_prices_rows(options={})
    Erp::Prices::Price.get_related_prices_rows(
      product_id: self.id,
      contact_id: options[:contact_id],
      category_id: self.category_id,
      properties_value_id: self.get_properties_value(Erp::Products::Property.getByName(Erp::Products::Property::NAME_DUONG_KINH)),
      letter_id: self.get_properties_value(Erp::Products::Property.getByName(Erp::Products::Property::NAME_CHU)),
      type: Erp::Prices::Price::TYPE_PURCHASE
    )
  end
  
  def get_related_sales_prices_rows(options={})
    Erp::Prices::Price.get_related_prices_rows(
      product_id: self.id,
      contact_id: options[:contact_id],
      category_id: self.category_id,
      properties_value_id: self.get_properties_value(Erp::Products::Property.getByName(Erp::Products::Property::NAME_DUONG_KINH)),
      letter_id: self.get_properties_value(Erp::Products::Property.getByName(Erp::Products::Property::NAME_CHU)),
      type: Erp::Prices::Price::TYPE_SALES
    )
  end
end


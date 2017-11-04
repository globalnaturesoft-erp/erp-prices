Erp::Contacts::Contact.class_eval do
  has_many :contact_prices, class_name: 'Erp::Prices::Price', foreign_key: :contact_id, dependent: :destroy
  accepts_nested_attributes_for :contact_prices, :reject_if => lambda { |a| a[:categories].blank? and a[:properties_values].blank? }, :allow_destroy => true
end

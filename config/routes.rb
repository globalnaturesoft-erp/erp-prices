Erp::Prices::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :backend, module: "backend", path: "backend/prices" do
      resources :customer_prices do
        collection do
          post 'contact_list'
          get 'line_form'
          get 'update_contact'
          get 'general'
          post 'general_list'
          get 'general_update'
          get 'do_update_contact'
          post 'do_update_contact'
        end
      end
      resources :supplier_prices do
        collection do
          post 'contact_list'
          get 'line_form'
          get 'update_contact'
          get 'general'
          post 'general_list'
          get 'general_update'
          get 'do_update_contact'
          post 'do_update_contact'
        end
      end
    end
  end
end
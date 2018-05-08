module Erp
  module Prices
    module Backend
      class CustomerPricesController < Erp::Backend::BackendController
        before_action :set_contact, only: [:update_contact, :do_update_contact, :general_update]

        # POST /customer_prices/contact_list
        def contact_list
          @contacts = Erp::Contacts::Contact.search(params)
            .where(is_customer: true)
            .where.not(id: Erp::Contacts::Contact.get_main_contact.id)
            .paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end
        
        def contact_list_details
          @contact = Erp::Contacts::Contact.find(params[:id])
          render layout: nil
        end

        # GET /customer_prices/1/edit
        def update_contact
        end

        # POST /customer_prices/general_list
        def general_list
          # @ todo update get categories
          @categories = Erp::Products::Category.search(params)
            .has_parent_categories
            .paginate(:page => params[:page], :per_page => 10)
        end

        # GET /customer_prices/1/edit
        def general_update
        end

        # PATCH/PUT /customer_prices/1
        def do_update_contact
          if @contact.update(contact_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @contact.contact_name,
                value: @contact.id
              }
            else
              if @contact == Erp::Contacts::Contact.get_main_contact
                redirect_to erp_prices.general_backend_customer_prices_path, notice: t('.success')
              else
                redirect_to erp_prices.backend_customer_prices_path, notice: t('.success')
              end
            end
          else
            render :edit_contact
          end
        end

        def line_form
          @customer_price = Price.new
          @customer_price.price_type = Erp::Prices::Price::TYPE_SALES
          @customer_price.contact_id = params[:add_value]

          render partial: params[:partial], locals: {
            customer_price: @customer_price,
            uid: helpers.unique_id()
          }
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_contact
            @contact = params[:contact_id].present? ? Erp::Contacts::Contact.find(params[:contact_id]) : Erp::Contacts::Contact.get_main_contact
          end

          # Only allow a trusted parameter "white list" through.
          def contact_params
            params.fetch(:contact, {}).permit(
              :contact_prices_attributes => [:id, :contact_id, :price_type,
                                              :min_quantity, :max_quantity, :price, :_destroy, :categories => [], :properties_values => [], :products => [], :letters => []]
              )
          end
      end
    end
  end
end

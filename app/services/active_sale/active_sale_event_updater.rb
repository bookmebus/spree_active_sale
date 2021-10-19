module ActiveSale
  class ActiveSaleEventUpdater < BaseService
    def call
      Spree::ActiveSaleEvent.transaction do
        if active_sale_event.update(permitted_resource_params)
          active_sale_event.products.update_all(
            flash_sale_discount: permitted_resource_params[:discount],
            flash_sale_start_date: permitted_resource_params[:start_date],
            flash_sale_end_date: permitted_resource_params[:end_date]
          )
        else
          context.success = false
          context.errors = active_sale_event.errors.messages
        end

        context
      end
    end

    private

    def active_sale_event
      @active_sale_event ||= attributes.fetch(:active_sale_event)
    end

    def permitted_resource_params
      attributes.fetch(:params)
    end
  end
end

module ActiveSale
  class ActiveSaleEventUpdater < BaseService
    def call
      Spree::ActiveSaleEvent.transaction do
        unless active_sale_event.update(permitted_resource_params)
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

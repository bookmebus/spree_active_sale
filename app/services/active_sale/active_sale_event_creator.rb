module ActiveSale
  class ActiveSaleEventCreator < BaseService
    def call
      Spree::ActiveSaleEvent.transaction do
        context.active_sale_event = Spree::ActiveSaleEvent.new(permitted_resource_params)

        unless context.active_sale_event.save
          context.success = false
          context.errors = context.active_sale_event.errors.messages
        end

        context
      end
    end

    private

    def permitted_resource_params
      attributes.fetch(:params)
    end
  end
end

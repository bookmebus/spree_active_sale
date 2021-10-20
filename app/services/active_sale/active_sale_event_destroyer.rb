module ActiveSale
  class ActiveSaleEventDestroyer < BaseService
    def call
      active_sale_event.destroy
    end

    private

    def active_sale_event
      attributes.fetch(:active_sale_event)
    end
  end
end

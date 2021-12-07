module ActiveSale
  class ActiveSaleEventResetter < BaseService
    def call
      return false if active_sale_event.end_date > Time.zone.now
      return false if active_sale_event.sale_products_count == 0

      #TODO reset product or remove denormalize from product
      CartSync.call(product_ids: active_sale_event.product_ids)
      active_sale_event.sale_products.update_all(is_active: false)
    end

    def active_sale_event
      @active_sale_event ||= Spree::ActiveSaleEvent.find(id)
    end

    def id
      attributes.fetch(:id)
    end
  end
end

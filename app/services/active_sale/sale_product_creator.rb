module ActiveSale
  class SaleProductCreator < BaseService
    def call
      sale_product = Spree::SaleProduct.new(
        product_id: product_id,
        discount: discount,
        active_sale_event: active_sale_event
      )
      context.sale_product = sale_product

      if sale_product.save!
        CartSyncJob.perform_later(product_ids: [product_id], last_updated_at: Time.zone.now)
      else
        context.success = false
        context.errors = context.active_sale_event.errors.messages
      end

      context
    end

    private

    def permitted_resource_params
      attributes.fetch(:params)
    end

    def active_sale_event
      attributes.fetch(:active_sale_event)
    end

    def product_id
      attributes.fetch(:product_id)
    end

    def discount
      attributes.fetch(:discount)
    end
  end
end

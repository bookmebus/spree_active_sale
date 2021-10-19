module ActiveSale
  class SaleProductCreator < BaseService
    def call
      Spree::SaleProduct.transaction do
        sale_product = Spree::SaleProduct.new(
          product_id: product_id,
          active_sale_event_id: active_sale_event.id
        )
        context.sale_product = sale_product

        if sale_product.save!
          sale_product.product.update(
            flash_sale_discount: active_sale_event.discount,
            flash_sale_start_date: active_sale_event.start_date,
            flash_sale_end_date: active_sale_event.end_date
          )
        else
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

    def active_sale_event
      attributes.fetch(:active_sale_event)
    end

    def product_id
      attributes.fetch(:product_id)
    end
  end
end

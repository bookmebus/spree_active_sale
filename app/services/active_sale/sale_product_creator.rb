module ActiveSale
  class SaleProductCreator < BaseService
    def call
      Spree::SaleProduct.transaction do
        context.errors = []
        context.sale_products = []
        product_ids.each do |product_id|
          sale_product = Spree::SaleProduct.new(
            product_id: product_id,
            active_sale_event_id: active_sale_event.id
          )

          if sale_product.save!
            Spree::ProductPromotionRule.create(
              product_id: product_id,
              promotion_rule_id: active_sale_event.promotion_rules.first.id,
              preferences: nil
            )
            context.sale_products << sale_product
          else
            context.success = false
            context.errors << sale_product.errors.messages
          end
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

    def product_ids
      attributes.fetch(:product_ids).uniq
    end
  end
end

class SaleProductCreator < ApplicationService
  def call
    Spree::SaleProduct.transaction do
      sale_product = Spree::SaleProduct.create!(
        product_id: product_id,
        active_sale_event_id: active_sale_event.id
      )

      Spree::ProductPromotionRule.create(
        product_id: product_id,
        promotion_rule_id: active_sale_event.promotion_rules.first.id,
        preferences: nil
      )

      sale_product
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

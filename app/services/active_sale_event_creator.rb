class ActiveSaleEventCreator < ApplicationService
  def call
    Spree::ActiveSaleEvent.transaction do
      promotion = Spree::Promotion.create!(
        name: name,
        description: description.first(255),
        starts_at: start_date,
        expires_at: end_date
      )
      active_sale_event = Spree::ActiveSaleEvent.create!(promotion_id: promotion.id, **permitted_resource_params)

      proption_rule = Spree::PromotionRule.create(
        promotion: active_sale_event.promotion,
        type: "Spree::Promotion::Rules::Product",
        preferences: {:match_policy=>"any"}
      )
      promotion_action = Spree::PromotionAction.create(
        promotion: active_sale_event.promotion,
        type: "Spree::Promotion::Actions::CreateItemAdjustments",
        preferences: nil
      )

      promotion_action.calculator.update(
        preferences: { percent: active_sale_event.discount }
      )

      active_sale_event
    end
  end

  private

  def permitted_resource_params
    attributes.fetch(:params)
  end

  def name
    permitted_resource_params["name"]
  end

  def start_date
    permitted_resource_params["start_date"]
  end

  def end_date
    permitted_resource_params["end_date"]
  end

  def description
    permitted_resource_params["description"]
  end
end

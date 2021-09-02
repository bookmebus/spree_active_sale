require 'spec_helper'

RSpec.describe CreatePromotion do
  it "creates promotion from acative sale event" do
    active_sale_event = create(:active_sale_event, discount: 30)
    CreatePromotion.call(active_sale_event: active_sale_event)

    active_sale_event.reload

    expect(active_sale_event.promotion).to have_attributes(
      description: active_sale_event.description.first(255),
      starts_at: active_sale_event.start_date,
      expires_at: active_sale_event.end_date
    )
    expect(active_sale_event.promotion.promotion_actions.first).to have_attributes(
      promotion: active_sale_event.promotion,
      type: "Spree::Promotion::Actions::CreateItemAdjustments",
      preferences: nil
    )
    expect(active_sale_event.promotion.promotion_actions.first.calculator).to have_attributes(
      type: "Spree::Calculator::PercentOnLineItem",
      calculable_type: "Spree::PromotionAction",
      calculable_id: active_sale_event.promotion_actions.last.id,
      preferences: { percent: 30}
    )
    expect(active_sale_event.promotion.promotion_rules.first).to have_attributes(
      promotion: active_sale_event.promotion,
      type: "Spree::Promotion::Rules::Product",
      preferences: {:match_policy=>"all"}
    )
  end
end

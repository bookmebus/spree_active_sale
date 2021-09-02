require 'spec_helper'

RSpec.describe DestroyPromotion do
  it "creates promotion from acative sale event" do
    active_sale_event = create(:active_sale_event)
    promotion = active_sale_event.promotion
    product = create(:product)
    promotion_rule = create(:promotion_rules_product, promotion: promotion)
    product_promotion_rule = create(:product_promotion_rule, promotion_rule: promotion_rule, product: product)
    promotion_action = create(:promotion_action, promotion: promotion)
    calculator = create(:calculator, calculable: promotion_action)
    promotion.reload

    DestroyPromotion.call(active_sale_event: active_sale_event)

    expect(promotion.promotion_rules).to be_blank
    expect(promotion.promotion_actions).to be_blank
  end
end

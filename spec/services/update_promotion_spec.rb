require 'spec_helper'

RSpec.describe UpdatePromotion do
  it "creates promotion from acative sale event" do
    promotion = create(
      :promotion,
      description: 'promotion description',
      starts_at: DateTime.now.yesterday,
      expires_at: DateTime.now.tomorrow
    )
    promotion_action = create(:promotion_action, promotion: promotion)
    calculator = create(:calculator, calculable: promotion_action)
    active_sale_event = create(
      :active_sale_event,
      promotion: promotion,
      discount: 30,
      description: 'bar',
      start_date: DateTime.now,
      end_date: DateTime.now.next_week
    )
    UpdatePromotion.call(active_sale_event: active_sale_event)

    expect(promotion.reload).to have_attributes(
      description: "bar",
      starts_at: active_sale_event.start_date,
      expires_at: active_sale_event.end_date
    )
  end
end

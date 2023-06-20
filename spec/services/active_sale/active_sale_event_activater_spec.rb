require 'spec_helper'

RSpec.describe ActiveSale::ActiveSaleEventActivator do
  it "activates event and deactivates other events" do
    event = build_event(is_active: false)
    other_event = build_event(is_active: true)


    ActiveSale::ActiveSaleEventActivator.call(active_sale_event: event)

    expect(event.reload.is_active).to eq(true)
    expect(other_event.reload.is_active).to eq(false)
  end

  it "deactivates event and not deactivates other events" do
    event = build_event(is_active: true)
    other_event = build_event(is_active: false)

    ActiveSale::ActiveSaleEventActivator.call(active_sale_event: event)

    expect(event.reload.is_active).to eq(false)
    expect(other_event.reload.is_active).to eq(false)
  end

  def build_event(is_active:)
    event = create(
      :active_sale_event,
      start_date: DateTime.now,
      end_date: DateTime.now.next_week,
    )

    event.update(is_active: is_active)

    product = create(:product)
    create(:sale_product, active_sale_event: event, product: product)

    event
  end
end

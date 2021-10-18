require 'spec_helper'

RSpec.describe ActiveSale::ActiveSaleEventUpdater do
  it "update sale event" do
    active_sale_event = create(
      :active_sale_event,
      discount: 30,
      description: 'bar',
      start_date: DateTime.now,
      end_date: DateTime.now.next_week
    )

    params = {
      discount: 20,
      description: 'Hello',
      start_date: "2021/09/07 20:27:49 +0700",
      end_date: "2021/09/08 20:27:49 +0700",
    }

    ActiveSale::ActiveSaleEventUpdater.call(active_sale_event: active_sale_event, params: params)

    expect(active_sale_event).to have_attributes(
      description: "Hello",
      start_date: DateTime.parse("2021/09/07 20:27:49 +0700").utc,
      end_date: DateTime.parse("2021/09/08 20:27:49 +0700").utc,
      discount: 20,
    )
  end
end

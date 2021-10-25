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
    product = create(
      :product,
      flash_sale_discount: active_sale_event.discount,
      flash_sale_start_date: active_sale_event.start_date,
      flash_sale_end_date: active_sale_event.end_date
    )
    sale_product = create(:sale_product, active_sale_event: active_sale_event, product: product)

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

    expect(product.reload).to have_attributes(
      flash_sale_discount: 20,
      flash_sale_start_date: DateTime.parse("2021/09/07 20:27:49 +0700").utc,
      flash_sale_end_date: DateTime.parse("2021/09/08 20:27:49 +0700").utc
    )
  end
end

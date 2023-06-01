require 'spec_helper'

RSpec.describe ActiveSale::SaleProductCreator do
  it "creates sale product from acative sale event" do
    product = create(:product)
    active_sale_event = create(
      :active_sale_event,
      discount: 30,
      description: 'bar',
      start_date: DateTime.now,
      end_date: DateTime.now.next_week
    )

    result = ActiveSale::SaleProductCreator.call(
      active_sale_event: active_sale_event.reload,
      product_id: product.id
    )

    expect(result.sale_product).to have_attributes(
      active_sale_event_id: active_sale_event.id,
      product_id: product.id
    )
  end
end

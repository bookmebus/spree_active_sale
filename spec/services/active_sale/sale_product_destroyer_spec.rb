require 'spec_helper'

RSpec.describe ActiveSale::SaleProductDestroyer do
  it "creates promotion from acative sale event" do
    active_sale_event = create(
      :active_sale_event,
      discount: 10,
      start_date: DateTime.now(),
      end_date: 2.days.from_now
    )
    product = create(
      :product
    )
    sale_product = create(:sale_product, active_sale_event: active_sale_event, product: product)

    ActiveSale::SaleProductDestroyer.call(sale_product: sale_product)

    expect(Spree::SaleProduct.exists?(sale_product.id)).to eq(false)
    expect(product.reload).to have_attributes(
      flash_sale_discount: nil,
      flash_sale_start_date: nil,
      flash_sale_end_date: nil
    )
  end
end

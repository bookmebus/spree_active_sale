require 'spec_helper'

RSpec.describe ActiveSale::SaleProductDestroyer do
  it "creates promotion from acative sale event" do
    active_sale_event = create(:active_sale_event)
    product = create(:product)
    sale_product = create(:sale_product, active_sale_event: active_sale_event, product: product)

    ActiveSale::SaleProductDestroyer.call(sale_product: sale_product)

    expect(Spree::SaleProduct.exists?(sale_product.id)).to eq(false)
  end
end

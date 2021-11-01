require 'spec_helper'

RSpec.describe ActiveSale::LineItemUpdater do
  it "recalculates price" do
    product = create(:product)

    result = ActiveSale::SaleProductCreator.call(
      product_ids: [product.id]
    )
  end
end


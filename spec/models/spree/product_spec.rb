require 'spec_helper'

describe "Spree::Product" do
  context ".is_effective_flash_sale?" do
    it "returns true if product is in flash sale event" do
      product = create(
        :product,
        flash_sale_start_date: DateTime.now(),
        flash_sale_end_date: 1.days.from_now,
        flash_sale_discount: 40
      )

      expect(product.is_effective_flash_sale?).to eq(true)
    end
  end
end

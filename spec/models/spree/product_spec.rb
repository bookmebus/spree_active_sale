require 'spec_helper'

describe "Spree::Product" do
  context ".is_effective_flash_sale?" do
    it "returns true if product is in flash sale event" do
      product = create(
        :product
      )

      expect(product.is_effective_flash_sale?).to eq(true)
    end
  end
end

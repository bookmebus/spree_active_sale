require 'spec_helper'

describe "Spree::Product" do
  context ".is_effective_flash_sale?" do
    it "returns false if product isn't in flash sale event" do
      product = create(
        :product
      )

      expect(product.is_effective_flash_sale?).to eq(false)
    end
  end
end

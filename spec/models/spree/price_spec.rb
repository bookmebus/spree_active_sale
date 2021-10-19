require 'spec_helper'

describe "Spree::Price" do
  context ".compare_at_amount" do
    it "returns value with default value of amount" do
      product = create(
        :product,
        flash_sale_start_date: DateTime.now(),
        flash_sale_end_date: 1.days.from_now,
        flash_sale_discount: 40
      )
      price = create(:price, variant: product.master, amount: 1000, compare_at_amount: nil, currency: "AUD")

      expect(price.compare_at_amount).to eq(1000)
    end

    it "returns value if compare_at_amount is present" do
      product = create(
        :product,
        flash_sale_start_date: DateTime.now(),
        flash_sale_end_date: 1.days.from_now,
        flash_sale_discount: 40
      )
      price = create(:price, variant: product.master, amount: 1000, compare_at_amount: 1200, currency: "AUD")

      expect(price.compare_at_amount).to eq(1200)
    end
  end

  context ".amount " do
    it "returns amount with discount if it is a price of flash sale variant" do
      product = create(
        :product,
        flash_sale_start_date: DateTime.now(),
        flash_sale_end_date: 1.days.from_now,
        flash_sale_discount: 40
      )
      price = create(:price, variant: product.master, amount: 1000, currency: "AUD")

      expect(price.amount).to eq(600)
    end
  end
end

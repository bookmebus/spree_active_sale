require 'spec_helper'

describe "Spree::Price" do
  context ".update_compare_at_amount" do
    it "returns value with default value of amount" do
      nil_price = create(:price, amount: 1000, compare_at_amount: nil, currency: "AUD")
      zero_price = create(:price, amount: 1000, compare_at_amount: nil, currency: "AUD")

      expect(nil_price[:compare_at_amount]).to eq(1000)
      expect(zero_price[:compare_at_amount]).to eq(1000)
    end
  end

  context ".compare_at_amount" do
    it "returns value with default value of amount" do
      product = create(
        :product
      )
      allow(product).to receive(:event_start_date).and_return(DateTime.now())
      allow(product).to receive(:event_end_date).and_return(1.days.from_now)
      allow(product).to receive(:event_discount).and_return(40)
      price = create(:price, variant: product.master, amount: 1000, compare_at_amount: nil, currency: "AUD")
      allow(price).to receive(:variant).and_return(product)

      expect(price.compare_at_amount).to eq(1000)
    end

    it "returns value if compare_at_amount is present" do
      product = create(
        :product
      )
      price = create(:price, variant: product.master, amount: 1000, compare_at_amount: 1200, currency: "AUD")

      expect(price.compare_at_amount).to eq(1200)
    end
  end

  context ".amount " do
    it "returns amount with discount if it is a price of flash sale variant" do
      product = create(
        :product
      )
      price = create(:price, variant: product.master, amount: 1000, currency: "AUD")

      expect(price.amount).to eq(600)
    end
  end
end

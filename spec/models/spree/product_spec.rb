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

  context ".event_discount" do
    it "returns sale_product discount" do
      active_sale_event = create(
        :active_sale_event,
        discount: 30,
        description: 'bar',
        start_date: DateTime.now,
        end_date: DateTime.now.next_week,
        is_active: true
      )
      active_sale_event.update(is_active: true)
      product = create(:product)
      other_product = create(:product)
      sale_product = create(
        :sale_product,
        active_sale_event: active_sale_event,
        product: product,
        discount: 50,
        is_active: true
      )
      other_sale_product = create(
        :sale_product,
        active_sale_event: active_sale_event,
        product: other_product,
        discount: nil
      )
      RequestStore.store[:effective_flash_sale] = active_sale_event.reload

      expect(product.reload.event_discount).to eq(50)
      expect(other_product.reload.event_discount).to eq(30)
    end
  end
end

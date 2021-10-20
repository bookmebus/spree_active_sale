require 'spec_helper'

RSpec.describe ActiveSale::ActiveSaleEventDestroyer do
  it "destroy active sale event" do
    active_sale_event = create(:active_sale_event)

    ActiveSale::ActiveSaleEventDestroyer.call(active_sale_event: active_sale_event)

    expect(Spree::ActiveSaleEvent.exists?(active_sale_event.id)).to eq(false)
  end
end

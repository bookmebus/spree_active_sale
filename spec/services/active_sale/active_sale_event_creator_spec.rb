require 'spec_helper'

RSpec.describe ActiveSale::ActiveSaleEventCreator do
  it "creates promotion from acative sale event" do
    active_sale = create(
      :active_sale,
      name: 'My promotion'
    )
    params = {
      "name"=>"Hello Cambodia",
      "description"=>"Hello",
      "start_date"=>"2021/09/07 20:27:49 +0700",
      "end_date"=>"2021/09/08 20:27:49 +0700",
      "discount"=>"40",
      "is_active"=>"1",
      "is_hidden"=>"1",
      "is_permanent"=>"0",
      "single_product_sale"=>"0",
      "active_sale_id" => active_sale.id
    }

    result = ActiveSale::ActiveSaleEventCreator.call(params: params)
    active_sale_event = result.active_sale_event.reload

    expect(active_sale_event).to have_attributes(
      name: "Hello Cambodia",
      description: "Hello",
      start_date: DateTime.parse("2021/09/07 20:27:49 +0700").utc,
      end_date: DateTime.parse("2021/09/08 20:27:49 +0700").utc,
      discount: 40,
      is_active: true,
      is_hidden: true,
      is_permanent: false,
      single_product_sale: false
    )
  end

  it "handles failed create active sale event" do
    active_sale = create(
      :active_sale,
      name: 'My promotion'
    )
    params = {
      "description"=>"Hello",
      "start_date"=>"2021/09/07 20:27:49 +0700",
      "end_date"=>"2021/09/08 20:27:49 +0700",
      "discount"=>"40",
      "is_active"=>"1",
      "is_hidden"=>"1",
      "is_permanent"=>"0",
      "single_product_sale"=>"0",
      "active_sale_id" => active_sale.id
    }

    result = ActiveSale::ActiveSaleEventCreator.call(params: params)

    expect(result.success).to eq(false)
    expect(result.active_sale_event.nil?).to eq(true)
    expect(result.errors).to eq(["Validation failed: Name can't be blank"])
  end
end

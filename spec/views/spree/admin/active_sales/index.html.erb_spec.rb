require 'spec_helper'

RSpec.describe "spree/admin/active_sales/index", type: :view do
  before(:each) do
    assign(:spree_active_sales, [
      instance_double(Spree::ActiveSale),
      instance_double(Spree::ActiveSale)
    ])
  end

  it "renders a list of spree/admin/active_sales/index" do
    # render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

require 'spec_helper'

RSpec.describe "spree/admin/active_sales/new", type: :view do
  before(:each) do
    assign(:spree_active_sale, Spree::ActiveSale.new)
  end

  it "renders new admin_active_sale form" do
    # render

    # # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "form", :action => spree.admin_active_sales_path, :method => "post" do
    # end
  end
end

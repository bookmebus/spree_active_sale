class AddSaleProductsCountToActiveSaleEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_active_sale_events, :sale_products_count, :integer
  end
end

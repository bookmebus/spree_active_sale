class AddIsEffectiveToSaleProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_sale_products, :is_active, :boolean, default: false
  end
end

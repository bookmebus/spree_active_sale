class AddDiscountToSaleProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_sale_products, :discount, :integer
  end
end

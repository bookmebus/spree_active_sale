class RemoveDenormalizeColumnsFromProduct < ActiveRecord::Migration[6.1]
  def change
    remove_column :spree_products, :flash_sale_discount, :integer
    remove_column :spree_products, :flash_sale_start_date, :datetime
    remove_column :spree_products, :flash_sale_end_date, :datetime
  end
end

class AddDiscountStartDateEndDateToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :flash_sale_discount, :integer
    add_column :spree_products, :flash_sale_start_date, :datetime
    add_column :spree_products, :flash_sale_end_date, :datetime
  end
end

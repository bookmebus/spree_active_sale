class MigrateDiscountFromEventToSaleProduct < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        Spree::ActiveSaleEvent.migrate_discount
      end
    end
  end
end

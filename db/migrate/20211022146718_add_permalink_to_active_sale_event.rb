class AddPermalinkToActiveSaleEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_active_sale_events, :permalink, :string, index: true
    add_index :spree_active_sale_events, [:permalink], :name => 'index_active_sale_event_on_permalink'
  end
end

class CartSyncJob < ApplicationJob
  # product_ids:, last_updated_at:
  def perform(options)
    ActiveSale::CartSync.call(options)
  end
end

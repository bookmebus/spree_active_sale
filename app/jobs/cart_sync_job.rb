class CartSyncJob < ApplicationJob
  def perform(product_ids:, last_updated_at:)
    CartSync.call(product_ids: product_ids, last_updated_at: last_updated_at)
  end
end

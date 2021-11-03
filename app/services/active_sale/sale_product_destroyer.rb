module ActiveSale
  class SaleProductDestroyer < BaseService
    def call
      sale_product.destroy

      CartSyncJob.perform_later(product_ids: [product_id], last_updated_at: Time.zone.now)
    end

    private

    def sale_product
      attributes.fetch(:sale_product)
    end
  end
end

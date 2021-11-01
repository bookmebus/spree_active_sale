module ActiveSale
  class SaleProductDestroyer < BaseService
    def call
      Spree::SaleProduct.transaction do
        Spree::SaleProduct.transaction do
          sale_product.product.update(
            flash_sale_discount: nil,
            flash_sale_start_date: nil,
            flash_sale_end_date: nil
          )
          sale_product.destroy
        end

        CartSyncJob.perform_later(product_ids: [product_id], last_updated_at: Time.zone.now)
      end
    end

    private

    def sale_product
      attributes.fetch(:sale_product)
    end
  end
end

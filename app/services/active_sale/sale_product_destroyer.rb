module ActiveSale
  class SaleProductDestroyer < BaseService
    def call
      Spree::SaleProduct.transaction do
        sale_product.destroy
      end
    end

    private

    def sale_product
      attributes.fetch(:sale_product)
    end
  end
end

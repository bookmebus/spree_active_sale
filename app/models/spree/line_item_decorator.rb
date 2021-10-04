module Spree
  module LineItemDecorator
    def live?
      self.product.live?
    end

    def flash_sale_product?
      self.product.flash_sale_product?
    end
  end
end

Spree::LineItem.prepend(Spree::LineItemDecorator)

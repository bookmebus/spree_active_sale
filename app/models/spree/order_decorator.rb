module Spree
  module OrderDecorator
    def delete_inactive_items
      self.line_items.each{ |line_item| line_item.destroy if line_item.flash_sale_product? && !line_item.live? }
    end
  end
end

Spree::Order.prepend(Spree::OrderDecorator)

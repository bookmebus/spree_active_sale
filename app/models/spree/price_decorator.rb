module Spree
  module PriceDecorator
    def self.prepended(base)
      base.before_validation :update_compare_at_amount
      base.after_save :update_line_items
    end

    def update_line_items
      if saved_change_to_compare_at_amount?
        CartSyncJob.perform_later(product_ids: [variant.product.id], last_updated_at: Time.zone.now)
      end
    end

    def update_compare_at_amount
      self[:compare_at_amount] = self[:amount] if self[:compare_at_amount].nil? || self[:compare_at_amount] == 0
    end

    # fall back compartibilty
    # if compare_at_amount is nil, display_price returns $0.00
    def compare_at_amount
      return self[:amount] if self["compare_at_amount"].nil? || self["compare_at_amount"].to_i == 0

      self["compare_at_amount"]
    end

    # decorate amount for flash sale
    def amount
      if variant&.is_effective_flash_sale?
        flash_sale_price = compare_at_amount.to_f * (100 - variant.event_discount) / 100

        flash_sale_price < self[:amount] ? flash_sale_price : self[:amount]
      else
        self[:amount]
      end
    end
  end
end

Spree::Price.prepend(Spree::PriceDecorator)

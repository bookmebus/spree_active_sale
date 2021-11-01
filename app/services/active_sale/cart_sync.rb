module ActiveSale
  class CartSync < BaseService
    def call
      pending_orders.includes(line_items: :variant).find_each do |order|
        update_cart(order)
      end
    end

    def product_ids
      attributes.fetch(:product_ids)
    end

    def last_updated_at
      attributes.fetch(:last_updated_at)
    end

    def pending_orders
      unique_order_ids = Spree::Order.select("DISTINCT(spree_orders.id)")
        .joins("INNER JOIN spree_line_items ON spree_orders.id=spree_line_items.order_id")
        .joins("INNER JOIN spree_variants ON spree_line_items.variant_id=spree_variants.id")
        .where("spree_variants.product_id": product_ids)
        .where("spree_line_items.updated_at > ?", last_updated_at)
        .where.not("spree_orders.state": 'complete')

      Spree::Order.where("id in (#{unique_order_ids.to_sql})")
    end

    def update_cart(order)
      order.line_items.each do |line_item|
        update_line_item(line_item)
      end

      update_order(order)
    end

    def update_order(order)
      order_updater = Spree::OrderUpdater.new(order)
      order_updater.update
    end

    def update_line_item(line_item)
      return unless product_ids.include?(line_item.variant.product_id)

      line_item.update_price
      line_item.save
    end
  end
end

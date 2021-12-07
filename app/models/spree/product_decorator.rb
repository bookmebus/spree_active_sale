module Spree
  module ProductDecorator
    def self.prepended(base)
      base.has_many :sale_products
      base.has_many :active_sale_events, :through => :sale_products
      # base.has_one  :effective_flash_sale: -> { where() }, through: :sale_products, class_name: 'Spree::ActiveSaleEvent'
      # base.has_one :effective_sale_product, -> { where(is_active: true) }, class_name: 'Spree::SaleProduct'

      base.delegate :available, :to => :active_sale_events, :prefix => true
      base.delegate :live_active, :to => :active_sale_events, :prefix => true
      base.delegate :live_active_and_hidden, :to => :active_sale_events, :prefix => true
    end

    def event_start_date
      effective_sale_product&.active_sale_event&.start_date
    end

    def event_end_date
      effective_flash_sale&.end_date
    end

    def event_discount
      effective_sale_product&.discount
    end

    def effective_flash_sale
      return Spree::ActiveSaleEvent.effective_flash_sale if sale_product_by_id[self.id]

      nil
    end

    def effective_sale_product
      sale_product_by_id[self.id]
    end

    def sale_product_by_id
      @sale_product_by_id ||= Spree::ActiveSaleEvent.effective_flash_sale.sale_products.index_by(&:product_id)
    end

    def is_effective_flash_sale?
      return false if event_start_date.blank? || event_end_date.blank?

      now = Time.zone.now
      event_start_date <= now && event_end_date > now
    end

    # Find live and active taxons for a product.
    def find_live_taxons
      Spree::Taxon.joins([:active_sale_events, :products]).where({ :spree_products => {:id => self.id} }).merge(Spree::ActiveSaleEvent.available)
    end

    # if there is at least one active sale event which is live and active.
    def live?
      !self.active_sale_events_available.blank? || !self.find_live_taxons.blank?
    end

    def flash_sale_product?
      !self.active_sale_events_available.blank?
    end
  end
end

Spree::Product.prepend(Spree::ProductDecorator)

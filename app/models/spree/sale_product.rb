module Spree
  class SaleProduct < ActiveRecord::Base
    belongs_to :active_sale_event, :class_name => 'Spree::ActiveSaleEvent', counter_cache: true
    belongs_to :product, :class_name => 'Spree::Product'

    delegate :product_name, :to => :product
    delegate :sale_name, :to => :active_sale_event

    validates :active_sale_event_id, :product_id, :presence => true
    validates :active_sale_event_id, :uniqueness => { :scope => :product_id, :message => I18n.t('spree.active_sale.event.sale_product.already_exists') }

    def self.search_product(name)
      joins("INNER JOIN spree_product_translations ON spree_sale_products.product_id=spree_product_translations.spree_product_id")
        .where(["spree_product_translations.name LIKE ?", "%#{name}%"])
    end

    def product_name
      product.try(:name)
    end

    def product_name=(name)
      self.product.name ||= name if name.present?
    end
  end
end

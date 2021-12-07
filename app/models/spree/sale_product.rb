module Spree
  class SaleProduct < ActiveRecord::Base
    belongs_to :active_sale_event, :class_name => 'Spree::ActiveSaleEvent', counter_cache: :sale_products_count
    belongs_to :product, :class_name => 'Spree::Product'

    delegate :product_name, :to => :product
    delegate :sale_name, :to => :active_sale_event

    validates :active_sale_event_id, :product_id, :presence => true
    validates :active_sale_event_id, :uniqueness => { :scope => :product_id, :message => I18n.t('spree.active_sale.event.sale_product.already_exists') }
    validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

    before_save :set_discount_value

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

    def set_discount_value
      self.discount = self.active_sale_event.discount if self.discount.blank?
    end
  end
end

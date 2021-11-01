# ActiveSaleEvent
# Events represent an entity/ schedule for active sale in a flash sale/ daily deal.
# There can be many events/ schedules for one sale.
#
module Spree
  class ActiveSaleEvent < ActiveRecord::Base
    has_many :sale_images, -> { order(position: :asc) },  :as => :viewable, :dependent => :destroy
    has_many :sale_products, -> { order(position: :asc) }, :dependent => :destroy
    has_many :products, -> { order(position: :asc) }, :through => :sale_products
    has_many :highlight_products, -> { limit(6) }, :through => :sale_products, source: :product
    has_many :sale_taxons, -> { order(position: :asc) }, :dependent => :destroy
    has_many :taxons, -> { order(position: :asc) }, :through => :sale_taxons
    has_many :sale_properties, :dependent => :destroy
    has_many :properties, :through => :sale_properties

    belongs_to :active_sale

    before_validation :update_permalink
    after_save :update_line_items

    validates :name, :start_date, :end_date, :active_sale_id, :presence => true
    validates :permalink, :uniqueness => true

    validate  :validate_start_and_end_date
    validate  :validate_with_live_event

    scope :active_and_not_expired, -> { where("start_date < ?", Time.zone.now.utc).where("end_date > ?", Time.zone.now.utc).where(deleted_at: nil) }
    scope :has_product_count, -> { where('sale_products_count>0') }
    scope :effective, -> { active_and_not_expired.has_product_count }

    class << self
      # Spree::ActiveSaleEvent.is_live? method
      # should only/ always represents live and active events and not just live events.
      def is_live? object
        object_class_name = object.class.name
        return object.live_and_active? if object_class_name == self.name
        %w(Spree::Product Spree::Variant Spree::Taxon).include?(object_class_name) ? object.live? : false
      end

      def paginate(options = {})
        options = prepare_pagination(options)
        self.page(options[:page]).per(options[:per_page])
      end

      private

        def prepare_pagination(options)
          per_page = options[:per_page].to_i
          options[:per_page] = per_page > 0 ? per_page : SpreeActiveSale::Config[:active_sale_events_per_page]
          page = options[:page].to_i
          options[:page] = page > 0 ? page : 1
          options
        end
    end

    def update_permalink
      self.permalink = self.name.parameterize if self.permalink.blank?
    end

    def update_line_items
      #TODO improve check with live?
      CartSyncJob.perform_later(product_ids: product_ids, last_updated_at: Time.zone.now) if self.saved_change_to_discount?
    end

    def to_param
      permalink.present? ? permalink : (permalink_was || self.name.parameterize.to_url)
    end

    # override the delete method to set deleted_at value
    # instead of actually deleting the event.
    def delete
      self.update_column(:deleted_at, object_zone_time)
    end

    # return product's or sale's with prefix permalink
    # def permalink
    #   self.single_product_sale? && product.present? ? product : active_sale
    # end

    def product
      products.first
    end

    def live?(moment=nil)
      moment = moment || object_zone_time

      (self.start_date <= moment && self.end_date >= moment) || self.is_permanent? if start_and_dates_available?
    end

    def upcoming?(moment=nil)
      moment = moment || object_zone_time

      (self.start_date >= moment && self.end_date > self.start_date) if start_and_dates_available?
    end

    def past?(moment=nil)
      moment = moment || object_zone_time

      (self.start_date < moment && self.end_date > self.start_date && self.end_date < moment) if start_and_dates_available?
    end

    def live_and_active?(moment=nil)
      self.live?(moment) && self.is_active?
    end

    def start_and_dates_available?
      self.start_date && self.end_date
    end

    def invalid_dates?
      self.start_and_dates_available? && (self.start_date >= self.end_date)
    end

    private

      # check if there is start and end dates are correct
      def validate_start_and_end_date
        errors.add(:start_date, I18n.t('spree.active_sale.event.validation.errors.invalid_dates')) if invalid_dates?
      end

      # check if there is no another event is currently live and active
      def validate_with_live_event
        if !active_sale.active_sale_events.where('id != :id', {:id => self.id}).select{ |ase| ase.live? }.blank? && self.live?
          errors.add(:another_event, I18n.t('spree.active_sale.event.validation.errors.live_event'))
        end
      end

      def object_zone_time
        Time.zone.now
      end
  end
end

require_dependency 'spree/active_sale_event/scopes'

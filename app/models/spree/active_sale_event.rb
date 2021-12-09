# ActiveSaleEvent
# Events represent an entity/ schedule for active sale in a flash sale/ daily deal.
# There can be many events/ schedules for one sale.
#
module Spree
  class ActiveSaleEvent < ActiveRecord::Base
    has_many :sale_images, -> { order(position: :asc) },  :as => :viewable, :dependent => :destroy
    has_many :sale_products, -> { order(position: :asc) }, :dependent => :destroy
    has_many :products, :through => :sale_products
    has_many :sale_taxons, -> { order(position: :asc) }, :dependent => :destroy
    has_many :taxons, -> { order(position: :asc) }, :through => :sale_taxons
    has_many :sale_properties, :dependent => :destroy
    has_many :properties, :through => :sale_properties

    belongs_to :active_sale

    before_validation :update_permalink
    before_create :set_default_value
    after_save :update_line_items
    after_create :create_with_end_date
    after_update :update_with_end_date

    validates :name, :start_date, :end_date, :active_sale_id, :presence => true
    validates :permalink, :uniqueness => true

    validate  :validate_start_and_end_date
    # validate  :validate_with_live_event

    scope :active_and_not_expired, -> { where("start_date < ?", Time.zone.now.utc).where("end_date > ?", Time.zone.now.utc).where(deleted_at: nil) }
    scope :not_expired, -> { where("start_date < ?", Time.zone.now.utc).where("end_date > ?", Time.zone.now.utc).where(deleted_at: nil) }
    scope :has_product_count, -> { where('sale_products_count>0') }
    scope :effective, -> { not_expired.has_product_count.order(is_active: :desc) }

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

    def self.migrate_discount
      sale_event_ids = Spree::ActiveSaleEvent
        .includes(:sale_products)
        .where(spree_sale_products: { discount: nil }).ids

      sale_event_ids.each do |sale_event_id|
        sale_event = Spree::ActiveSaleEvent.find(sale_event_id)
        Spree::SaleProduct.where(active_sale_event_id: sale_event_id)
          .update(discount: sale_event.discount)
      end
    end

    # if no effective_flash_sale then it keeps making query because of the nil result
    # return false instead of nil
    def self.effective_flash_sale
      # RequestStore.store[:effective_flash_sale] ||= active.effective.first
      return  RequestStore.store[:effective_flash_sale] if !RequestStore.store[:effective_flash_sale].nil?
      result = active.effective.first

      result = result.nil? ? false : result
      RequestStore.store[:effective_flash_sale] = result

      RequestStore.store[:effective_flash_sale]
    end

    def set_default_value
      self.is_active = false
    end

    def update_permalink
      self.permalink = self.name.parameterize if self.permalink.blank?
    end

    def create_with_end_date
      if self.end_date > Time.zone.now
        wait_time = (Time.zone.now - self.end_date).to_i
        ActiveSaleEventResetterJob.set(wait: wait_time.seconds).perform_later(self.id)
      end
    end

    def update_with_end_date
      if self.saved_change_to_end_date?
        interval = (self.end_date - Time.zone.now).to_i
        wait_time = interval >= 0? interval : 0
        ActiveSaleEventResetterJob.set(wait: wait_time.seconds).perform_later(self.id)
      end
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

    def activatable?
      moment = Time.zone.now

      return false unless start_and_dates_available?
      return false if sale_products_count == 0

      self.start_date <= moment && self.end_date >= moment
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
      # def validate_with_live_event
      #   if !active_sale.active_sale_events.where('id != :id', {:id => self.id}).select{ |ase| ase.live? }.blank? && self.live?
      #     errors.add(:another_event, I18n.t('spree.active_sale.event.validation.errors.live_event'))
      #   end
      # end

      def object_zone_time
        Time.zone.now
      end
  end
end

require_dependency 'spree/active_sale_event/scopes'

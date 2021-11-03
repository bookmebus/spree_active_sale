module ActiveSale
  class ActiveSaleEventActivator < BaseService
    def call
      unless active_sale_event.activatable?
        context.error = "is not activatable"
        context.sucess = false
      else
        toggle_active_sale_event
        update_other_events
      end


      context
    end

    private

    def toggle_active_sale_event
      active_sale_event.is_active = !active_sale_event.is_active
      active_sale_event.save!
    end

    def update_other_events
      return if active_sale_event.is_active? == false

      Spree::ActiveSaleEvent.where.not(id: active_sale_event.id).update_all(is_active: false)
    end

    def active_sale_event
      @active_sale_event ||= attributes.fetch(:active_sale_event)
    end
  end
end

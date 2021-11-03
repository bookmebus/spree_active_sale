module Spree
  module Admin
    class ActiveSaleEventsController < ResourceController
      before_action :load_active_sale, :only => :index
      before_action :load_data, :except => :index

      def create
        active_sale_event_params = permitted_resource_params.merge(active_sale_id: @active_sale.id)
        context = ::ActiveSale::ActiveSaleEventCreator.call(params: active_sale_event_params)
        @active_sale_event = context.active_sale_event

        if context.success
          flash[:success] = flash_message_for(@active_sale_event, :successfully_created)
          respond_with(@active_sale_event) do |format|
            format.html { redirect_to location_after_save }
            format.js   { render layout: false }
          end
        else
          respond_with(@active_sale_event) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      def update
        context = ::ActiveSale::ActiveSaleEventUpdater.call(active_sale_event: @object, params: permitted_resource_params)
        if context.success
          respond_with(@object) do |format|
            format.html do
              flash[:success] = flash_message_for(@object, :successfully_updated)
              redirect_to location_after_save
            end
            format.js { render layout: false }
          end
        else
          invoke_callbacks(:update, :fails)
          respond_with(@object) do |format|
            format.html { render action: :edit }
            format.js { render layout: false }
          end
        end
      end

      def show
        session[:return_to] ||= request.referer
        redirect_to( :action => :edit )
      end

      def destroy
        ::ActiveSale::ActiveSaleEventDestroyer.call(active_sale_event: @active_sale_event)

        flash.notice = I18n.t('spree.active_sale.notice_messages.event_deleted')

        respond_with(@active_sale_event) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      def toggle_event
        context = ::ActiveSale::ActiveSaleEventActivator.call(active_sale_event: find_resource)

        if context.success
          flash[:success] = flash_message_for(@object, :successfully_updated)
        else
          flash[:error] = context.message
        end

        redirect_to( :action => :index )
      end

      private

        def location_after_save
          edit_admin_active_sale_active_sale_event_url(@active_sale, @active_sale_event)
        end

      protected

        def find_resource
          Spree::ActiveSaleEvent.find_by!(permalink: params[:id])
        end

        def collection_url
          edit_admin_active_sale_url(@active_sale)
        end

        def collection
          return @collection if @collection.present?
          params[:q] ||= {}
          params[:q][:deleted_at_null] ||= "1"

          params[:q][:s] ||= "name asc"

          @search = Spree::ActiveSaleEvent.where(:active_sale_id => params[:active_sale_id]).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(SpreeActiveSale::Config[:admin_active_sale_events_per_page])
        end

        def load_active_sale
          @active_sale = Spree::ActiveSale.find_by!(permalink: params[:active_sale_id])
          @active_sale_events = @active_sale.active_sale_events
        end

        def load_data
          @active_sale = Spree::ActiveSale.find_by!(permalink: params[:active_sale_id])
          @active_sale_event ||= @active_sale.active_sale_events.find_by!(permalink: params[:active_sale_event_id])
          @taxons = Taxon.order(:name)
          @shipping_categories = ShippingCategory.order(:name)
        end
    end
  end
end

module Spree
  module Api
    module V2
      class ActiveSaleEventProductsController < ResourceController
        def collection
          active_sale_event.products.includes(:translations, vendor: :translations, master: :images)
        end

        def collection_serializer
          Spree::V2::Storefront::ProductSerializer
        end

        private

        def active_sale_event
          Spree::ActiveSaleEvent.find_by!(permalink: params[:active_sale_event_id], deleted_at: nil)
        end
      end
    end
  end
end

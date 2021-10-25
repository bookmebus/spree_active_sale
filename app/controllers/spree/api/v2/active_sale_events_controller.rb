module Spree
  module Api
    module V2
      class ActiveSaleEventsController < Spree::Api::V2::ResourceController
        def collection
          Spree::ActiveSaleEvent.active.active_and_not_expired.includes(highlight_products: [:translations, vendor: :translations, master: :images], sale_images: :attachment_blob)
        end

        def resource_serializer
          Spree::V2::ActiveSale::ActiveSaleEventSimpleSerializer
        end

        def collection_serializer
          Spree::V2::ActiveSale::ActiveSaleEventSerializer
        end

        def resource
          Spree::ActiveSaleEvent.find(params[:id])
        end
      end
    end
  end
end

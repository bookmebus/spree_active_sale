module Spree
  module Api
    module V2
      module ActiveSale
        class ProductsController < ResourceController
          def collection
            active_sale_event.products.includes(master: :images)
          end

          def collection_serializer
            Spree::V2::ActiveSale::ProductSerializer
          end

          private

          def active_sale_event
            Spree::ActiveSaleEvent.find(params[:active_sale_event_id])
          end
        end
      end
    end
  end
end

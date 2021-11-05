module Spree
  module V2
    module ActiveSale
      class ActiveSaleEventSimpleSerializer < ::Spree::V2::Storefront::BaseSerializer
        attributes :name, :permalink, :description, :start_date, :end_date, :discount

        has_many :sale_images, serializer: :cover_image
      end
    end
  end
end

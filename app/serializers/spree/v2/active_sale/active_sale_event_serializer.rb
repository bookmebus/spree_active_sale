module Spree
  module V2
    module ActiveSale
      class ActiveSaleEventSerializer < ::Spree::V2::Storefront::BaseSerializer
        attributes :name, :description, :start_date, :end_date, :discount

        has_many :highlight_products, serializer: :product
        has_many :sale_images, serializer: :cover_image
      end
    end
  end
end

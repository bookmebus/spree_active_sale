module Spree
  module V2
    module ActiveSale
      class ProductSerializer < ::Spree::V2::Storefront::BaseSerializer
        include ::Spree::Api::V2::DisplayMoneyHelper

        set_type :product

        attributes :name, :description, :price, :available_on, :slug

        # all images from all variants
        has_many :images,
          object_method_name: :variant_images,
          id_method_name: :variant_image_ids,
          record_type: :image,
          serializer: Spree::V2::Storefront::ImageSerializer
      end
    end
  end
end

module Spree
  module V2
    module ActiveSale
      class ProductSerializer < ::Spree::V2::Storefront::BaseSerializer
        include ::Spree::Api::V2::DisplayMoneyHelper

        set_type :product

        attributes :name, :description, :available_on, :slug

        attribute :price do |product, params|
          price(product, params[:currency])
        end

        attribute :compare_at_price do |product, params|
          compare_at_price(product, params[:currency])
        end

        # all images from all variants
        has_many :images,
          object_method_name: :variant_images,
          id_method_name: :variant_image_ids,
          record_type: :image,
          serializer: Spree::V2::Storefront::ImageSerializer

        belongs_to :vendor, serializer: :vendor_simple
      end
    end
  end
end

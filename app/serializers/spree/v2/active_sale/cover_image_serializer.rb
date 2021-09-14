module Spree
  module V2
    module ActiveSale
      class CoverImageSerializer < ::Spree::V2::Storefront::BaseSerializer
        set_type :cover_image

        attributes :viewable_type, :viewable_id, :styles
      end
    end
  end
end


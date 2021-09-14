module Spree
  module V2
    module ActiveSale
      class ActiveSaleEventSimpleSerializer < ::Spree::V2::Storefront::BaseSerializer
        attributes :name, :description, :start_date, :end_date, :discount
      end
    end
  end
end

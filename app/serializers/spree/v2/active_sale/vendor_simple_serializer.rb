module Spree
  module V2
    module ActiveSale
      class VendorSimpleSerializer < ::Spree::V2::Storefront::BaseSerializer
        set_type   :vendor_simple

        attributes :name, :slug, :vendor_type, :about_us, :contact_us

        attribute :is_type_vmall do |vendor|
          vendor.type_vmall?
        end
      end
    end
  end
end

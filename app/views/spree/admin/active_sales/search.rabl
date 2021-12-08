object false
child(@products => :products) do |products|
  attributes :id
  node(:name) do |product|
    if product.vendor.present?
      "#{product.sku}-#{product.name} (#{product.vendor&.name})"
    else
      "#{product.sku}-#{product.name}"
    end
  end
end

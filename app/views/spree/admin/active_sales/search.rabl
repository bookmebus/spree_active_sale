object false
child(@products => :products) do |products|
  attributes :id
  node(:name) do |product|
    if product.vendor.present?
      "#{product.name} (#{product.vendor&.name})"
    else
      product.name
    end
  end
end

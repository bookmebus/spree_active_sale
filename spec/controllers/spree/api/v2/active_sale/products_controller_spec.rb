require 'spec_helper'

RSpec.describe Spree::Api::V2::ActiveSale::ProductsController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe "GET index" do
    it "lists all active sale products of active sale event" do
      Spree::ActiveSale.destroy_all
      active_sale_event = create(:active_sale_event)
      product = create(:product)
      sale_product = create(:sale_product, product: product, active_sale_event: active_sale_event)
      other_product = create(:product)

      get :index, params: { active_sale_event_id: active_sale_event.id }

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["data"].size).to eq(1)
      expect(json_response["data"][0]["id"]).to eq(product.id.to_s)
      expect(json_response["data"][0]["attributes"]["price"]).to eq("19.99")
      expect(json_response["data"][0]["attributes"]["compare_at_price"]).to eq("19.99")
    end
  end
end

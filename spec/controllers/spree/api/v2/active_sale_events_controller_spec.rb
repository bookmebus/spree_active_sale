require 'spec_helper'

RSpec.describe Spree::Api::V2::ActiveSaleEventsController, type: :controller do
  routes { Spree::Core::Engine.routes }
  let(:active_sale_event) { create(:active_sale_event) }
  let(:product) { create(:product) }
  let(:sale_product) { create(:sale_product, product: product, active_sale_event: active_sale_event) }

  before do
    Spree::ActiveSale.destroy_all
    active_sale_event.update(is_active: true)
  end

  describe "GET index" do
    it "lists all active sale events with status active" do
      active_sale_event_with_no_product = create(:active_sale_event)

      get :index

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["data"][0]["id"]).to eq(active_sale_event.id.to_s)
      expect(json_response["data"][0]["attributes"]).to eq({
        "description" => active_sale_event.description,
        "discount" => nil,
        "end_date" => active_sale_event.end_date.iso8601(3),
        "name" => active_sale_event.name,
        "start_date" => active_sale_event.start_date.iso8601(3)
      })
    end
  end

  describe "GET show" do
    it "shows details of active_sale_event" do
      get :show, params: { id: active_sale_event.permalink }

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["data"]["id"]).to eq(active_sale_event.id.to_s)
      expect(json_response["data"]["attributes"]).to eq({
        "description" => active_sale_event.description,
        "discount" => nil,
        "end_date" => active_sale_event.end_date.iso8601(3),
        "name" => active_sale_event.name,
        "permalink" => active_sale_event.permalink,
        "start_date" => active_sale_event.start_date.iso8601(3)
      })
    end
  end
end

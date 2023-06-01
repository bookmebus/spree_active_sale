# coding: UTF-8
require 'spec_helper'

describe Spree::ProductsController, type: :controller do
  routes { Spree::Core::Engine.routes }

  let!(:user) { create(:user) }

  let(:active_sale_event) { create(:active_sale_event_with_products) }
  let(:inactive_sale_event) { create(:inactive_sale_event_with_products) }

  before do
    allow_any_instance_of(Spree::ProductsController).to receive(:spree_current_user).and_return(user)
    user.stub :has_spree_role? => true
    active_sale_event.update(is_active: true)
  end

  describe "GET show" do
    context "when sale event is live and active" do
      it "then product view page should be accessible" do
        event = active_sale_event
        product = event.products.first

        expect(event.live_and_active?).to eq(true)
        expect(product.live?).to eq(true)

        get :show, params: { id: product.to_param }

        expect(response.status).to eq(200)
      end
    end

    context "when sale event is not live and inactive" do
      it "then product view page should not be accessible" do
        event = inactive_sale_event
        product = event.products.first

        expect(event.live_and_active?).to eq(false)
        expect(product.live?).to eq(false)

        get :show, params: { id: product.to_param }

        expect(response).to redirect_to(root_url)
      end
    end
  end
end

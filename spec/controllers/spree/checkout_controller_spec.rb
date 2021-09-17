# coding: UTF-8
require 'spec_helper'

RSpec.describe Spree::CheckoutController, type: :controller do
  routes { Spree::Core::Engine.routes }

  let(:token) { 'some_token' }
  let(:user) { instance_double(Spree::LegacyUser) }
  let(:order) { order = FactoryBot.create(:order_with_totals) }

  before do
    allow(user).to receive(:id).and_return(1)
    allow(user).to receive(:orders).and_return(Spree::Order.all)
    allow_any_instance_of(Spree::CheckoutController).to receive(:try_spree_current_user).and_return(user)
    allow_any_instance_of(Spree::CheckoutController).to receive(:current_order).and_return(order)
  end

  let(:active_sale_event_with_products) { FactoryBot.create(:active_sale_event_with_products) }

  context "#edit" do
    it 'should check if the event is live for :edit' do
      expect(order).to receive(:delete_inactive_items)

      get :edit, params: { state: 'address'}, session: { access_token: token }
    end
  end
end

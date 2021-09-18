require 'spec_helper'

RSpec.describe Spree::HomeController, type: :controller do
  routes { Spree::Core::Engine.routes }

  let(:user) { instance_double(Spree::User, :last_incomplete_spree_order => nil, :spree_api_key => 'fake') }
  let(:sale) { create(:active_sale_with_events, :events_count => 2) }

  before do
    allow_any_instance_of(Spree::HomeController).to receive(:spree_current_user).and_return(user)
  end

  describe "GET index" do
    it "assigns all active_sale_events as @active_sale_events" do
      get :index

      expect(assigns(:sale_events)).to eq(Spree::ActiveSaleEvent.live_active.to_a)
    end
  end

end

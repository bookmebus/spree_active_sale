require 'spec_helper'

describe Spree::ActiveSaleEvent do
  it "should not save when name is not given" do
    active_sale = create(:active_sale)
    active_sale_event = Spree::ActiveSaleEvent.new
    active_sale_event.name = " "
    active_sale_event.active_sale = active_sale
    active_sale_event.save

    expect(active_sale_event.new_record?).to eq(true)
  end

  context 'Effective scope' do
    it "should return only active and not expired active event" do
      Spree::ActiveSaleEvent.destroy_all
      active = create(:active_sale_event, start_date: 2.days.ago, end_date: 1.days.from_now, is_active: true)
      inactive = create(:active_sale_event, start_date: 2.days.ago, end_date: 1.days.from_now, is_active: false)
      expired = create(:active_sale_event, start_date: 2.days.ago, end_date: 1.days.ago, is_active: true)

      result = Spree::ActiveSaleEvent.effective

      expect(result.size).to eq(1)
      expect(result.first).to eq(active)
    end
  end

  context "Eventable's instace methods" do
    let(:active_sale_event) { create :active_sale_event }

    context '#live?' do
      it "should accept the moment when the instance should be live" do
        active_sale_event.start_date = 5.days.from_now
        active_sale_event.end_date = 7.days.from_now

        expect(active_sale_event.live?(6.days.from_now)).to eq(true)
        expect(active_sale_event.live?).to eq(false)
        Time.should_not_receive(:zone)
      end
    end

    context '#live_and_active?' do
      it "should pass the moment to #live? if present" do
        now = Time.now
        active_sale_event.should_receive(:live?).with(now)
        active_sale_event.live_and_active? now
      end
    end
  end
end

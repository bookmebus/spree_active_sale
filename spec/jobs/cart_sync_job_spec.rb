require 'spec_helper'

RSpec.describe CartSyncJob do
  describe '#perform' do
    it 'calls ActiveSale::CartSync' do
      options = {
        product_ids: [1,2],
        last_updated_at: Date.new(2021,12,28)
      } 

      expect(ActiveSale::CartSync).to receive(:call).with(options)
      CartSyncJob.new.perform(options)
    end
  end
end
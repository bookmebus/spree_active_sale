class ActiveSaleEventResetterJob < ApplicationJob
  def perform(id)
    ActiveSale::ActiveSaleEventResetter.call(id: id)
  end
end

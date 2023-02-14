require "spec_helper"

RSpec.describe BurgerOrder do
  it "calculates the prices for an order" do
    order_file = File.absolute_path("spec/fixtures/order.json")
    expect(BurgerOrder.calculate_total_price(order_file)).to eq(16.29)
  end
end

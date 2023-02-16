require "spec_helper"
require 'pry-byebug'

RSpec.describe BurgerOrder do
  it "calculates the prices for a finstreet-order" do
    order_file = File.absolute_path("spec/fixtures/order.json")
    expect(BurgerOrder.calculate_total_price(order_file)).to eq(12.73)
  end

  it "calculates the price for 4 hamburgers, no specials" do
    order_file = File.absolute_path("spec/fixtures/order_2.json")
    expect(BurgerOrder.calculate_total_price(order_file)).to eq(14.00)
  end

  it "calculates the price for 3 different burgers, no specials" do
    order_file = File.absolute_path("spec/fixtures/order_3.json")
    expect(BurgerOrder.calculate_total_price(order_file)).to eq(19.00)
  end

  it "calculates the price for 3 different burgers, one not existent" do
    order_file = File.absolute_path("spec/fixtures/order_4.json")
    expect(BurgerOrder.calculate_total_price(order_file)).to eq(11.00)
  end

  it "calculates the price for 3 hamburgers, different sizes" do
    order_file = File.absolute_path("spec/fixtures/order_5.json")
    expect(BurgerOrder.calculate_total_price(order_file)).to eq(15.00)
  end

  it "calculates the price for 3 burgers with 3 for 1 promotion, no specials" do
    order_file = File.absolute_path("spec/fixtures/order_6.json")
    expect(BurgerOrder.calculate_total_price(order_file)).to eq(3.5)
  end

  it "calculates the price for 3 different burgers with 3 for 1 promotion with specials" do
    order_file = File.absolute_path("spec/fixtures/order_7.json")
    expect(BurgerOrder.calculate_total_price(order_file)).to eq(7.35)
  end
end

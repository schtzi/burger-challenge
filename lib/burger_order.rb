require 'json'
require 'pry-byebug'

module BurgerOrder
  class Data
    attr_reader :burgers, :size_multipliers, :ingredients, :promotions, :discounts

    def initialize
      content = JSON.parse(File.read('lib/data.json'))

      @size_multipliers = content['size_multipliers']
      @burgers = content['burgers']
      @ingredients = content['ingredients']
      @promotions = content['promotions']
      @discounts = content['discounts']
    end
  end

  class Order
    attr_reader :content, :promotions, :discount

    def initialize(order_file)
      order_data = JSON.parse(order_file)
      @content = []

      order_data['items'].each do |item|
        @content << Burger.new(name: item['name'], size: item['size'], add: item['add'], remove: item['remove'])
      end

      @promotions = order_data['promotion_codes']
      @discount = order_data['discount_code']
    end

    def total_value
      @content.sum(&:extras_price) + @content.sum(&:burger_price)
    end
  end

  class Burger
    attr_accessor :name, :size, :add, :remove, :burger_price, :extras_price

    def initialize(attributes)
      @name = attributes[:name]
      @size = attributes[:size]
      @add = attributes[:add]
      @remove = attributes[:remove]

      add_prices
    end

    def add_prices
      @data = Data.new

      @burger_price = @data.burgers[@name] * @data.size_multipliers[@size]
      @extras_price = 0

      return unless @add.any?

      @add.each do |extra|
        next if @data.ingredients[extra].nil?

        @extras_price += @data.ingredients[extra] * @data.size_multipliers[@size]
      end
    end

    def self.all
      ObjectSpace.each_object(self).to_a
    end

    def self.count
      all.count
    end
  end

  def self.calculate_total_price(order_file)
    data = Data.new
    order = Order.new(order_file)
    order.discount.any? ? apply_discount(order, data) : order.total_value

    # apply_discount = (order.sum(&:extras_price) + price_after_promo(order.content))
  end

  def self.apply_discount(order, data)
    discount_data = data.discounts[order.discount]
    case discount_data
    when 'deduction_in_percent'
      order.total_value * (1 - discount_data['deduction_in_percent'] / 100)
    when 'deduction_in_euro'
      order.total_value - discount_data['deduction_in_euro']
    when 'deduction_in_cents'
      order.total_value - (discount_data['deduction_in_euro'] / 100)
    else
      order.total_value
    end
  end
end

BurgerOrder.calculate_total_price(File.read('spec/fixtures/order.json'))

require 'json'
require 'pry-byebug'

module BurgerOrder
  # before_action :load_database, only: :calculate_total_price

  # def self.load_database
  #   @@data = Data.new
  # end

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
    attr_accessor :total_value

    def initialize(order_file)
      order_data = JSON.parse(File.read(order_file))
      @content = []

      order_data['items'].each do |item|
        @content << Burger.new(name: item['name'], size: item['size'], add: item['add'], remove: item['remove'])
      end

      @promotions = order_data['promotion_codes']
      @discount = order_data['discount_code']
      @total_value = @content.sum(&:extras_price) + @content.sum(&:burger_price)
    end
  end

  class Burger
    attr_accessor :name, :size, :add, :remove, :burger_price, :extras_price

    def initialize(attributes)
      @data = Data.new # needs to be refactored so that it's only done once
      @name = attributes[:name]
      @size = attributes[:size]
      @add = attributes[:add]
      @remove = attributes[:remove]

      add_prices
    end

    def add_prices
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
  end

  def self.calculate_total_price(order_file_path)
    order = Order.new(order_file_path)
    data = Data.new # needs to be refactored so that it's only done once

    order.promotions.nil? ? order.total_value : apply_promotions(order, data)
    order.discount.empty? ? order.total_value : apply_discount(order, data)

  end

  def self.apply_promotions(order, data)
    order.promotions.each do |promo|
      promo_data = data.promotions[promo]

      count = Burger.all.count { |b| b.name == promo_data['target'] && b.size == promo_data['target_size'] }
      relevant_count = count - (count % promo_data['from'])
      number_of_possible_promotions = relevant_count / promo_data['from']
      reduction = number_of_possible_promotions / (promo_data['from'] - promo_data['to'])

      order.total_value -= (reduction * data.burgers[promo_data['target']] * data.size_multipliers[promo_data['target_size']])
    end
    order.total_value.round(2)
  end

  def self.apply_discount(order, data)
    discount_data = data.discounts[order.discount]
    case discount_data.keys[0]
    when 'deduction_in_percent'
      order.total_value = (order.total_value * (1 - (discount_data['deduction_in_percent'] / 100.0))).round(2)
    when 'deduction_in_euro'
      order.total_value -= discount_data['deduction_in_euro']
    when 'deduction_in_cents'
      order.total_value -= (discount_data['deduction_in_euro'] / 100)
    else
      order.total_value
    end
  end
end

BurgerOrder.calculate_total_price('spec/fixtures/order.json')

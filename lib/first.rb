



#   def self.calculate_total_price(order_file)
#     order = JSON.parse(order_file)
#     data = JSON.parse(File.read('lib/data.json'))

#     order['items'] = add_prices(order['items'], data)
#     calculate_price(order, data)
#   end

#   def self.calculate_price(order, data)
#     price = 0
#     order = apply_promotion(order, data)
#     order['items'].each do |burger|
#       price += burger['price']
#       price += burger['extras_price']
#     end
#     apply_discount(price, order, data)
#   end

#   def self.apply_discount(price, order, data)
#     deduction = data['discounts'][order['discount_code']]['deduction_in_percent']
#     price * (1 - (deduction / 100.0))
#   end

#   def self.apply_promotion(order, data)
#     order['promotion_codes'].each do |order_code|
#       data_code = data['promotions'][order_code]
#       target = data_code['from']
#       counter = 0
#       order['items'].each do |burger|
#         if data_code['target'] == burger['name'] &&
#            data_code['target_size'] == burger['size']
#           counter += 1
#           if counter < target && counter >= data_code['to']
#             burger['price'] = 0
#           end
#           if counter == target
#             counter = 0
#           end
#         end
#       end
#     end
#     order
#   end

#   def self.add_prices(items, data)
#     items.each do |item|
#       item['price'] = data['burgers'][item['name']] * data['size_multipliers'][item['size']]
#       item['extras_price'] = 0
#       item['add'].each do |extra|
#         unless data['ingredients'][extra].nil?
#           item['extras_price'] += data['ingredients'][extra] * data['size_multipliers'][item['size']]
#         end
#       end
#     end
#     items
#   end
# end

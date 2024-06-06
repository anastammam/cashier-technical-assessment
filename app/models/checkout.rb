require_relative 'price_rules'

class Checkout
	include PriceRules
	attr_accessor :products, :amount

	def initialize(price_rules = [])
		@price_rules = price_rules
		@products = []
		@amount = 0.0
		@total_amount = 0.0
	end

	def scan(product)
		@products.push(product)
		@amount += product[:price]
	end

	def total
		discount!
		return @total_amount.round(2)
	end

	def basket
		return @products
	end

	private

	def discount!
		return if @price_rules.empty? || @products.empty?

		@total_amount = @amount
		@price_rules.each do |price_rule|
			send("#{price_rule[:type]}!", price_rule)
		end
	end

end
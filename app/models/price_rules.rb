module PriceRules
	def product_discount!(price_rule)
		targeted_products = @products.select { |product| product[:code] == price_rule[:product_code] }
		return if targeted_products.empty?
		product_price = targeted_products.first[:price]

		products_count = targeted_products.count
		buy_offer = price_rule[:quantity]
		get_offer = price_rule[:amount]
		free_products = 
			buy_x_get_y_free_products(products_count, buy_offer, get_offer)

		products_price = targeted_products.sum(&:price)
		discounted_products_price = (products_count - free_products) * product_price

		apply_on_total_amount!(products_price, discounted_products_price)
	end

	def cash_discount!(price_rule)
		targeted_products = @products.select { |product| product[:code] == price_rule[:product_code] }
		return if targeted_products.empty?
		return if targeted_products.count < price_rule[:quantity]

		products_price = targeted_products.sum(&:price)
		cash_discount_amount = targeted_products.count * price_rule[:amount]
		discounted_products_price = products_price - cash_discount_amount

		apply_on_total_amount!(products_price, discounted_products_price)
	end

	def percentage_discount!(price_rule)
		targeted_products = @products.select { |product| product[:code] == price_rule[:product_code] }
		return if targeted_products.empty?
		return if targeted_products.count < price_rule[:quantity]

		products_price = targeted_products.sum(&:price)
		discounted_products_price = products_price * price_rule[:amount]

		apply_on_total_amount!(products_price, discounted_products_price)
	end

	private
	
	def apply_on_total_amount!(actual_products_price, discounted_products_price)
		return if actual_products_price.nil? || discounted_products_price.nil?

		@total_amount -= actual_products_price
		@total_amount += discounted_products_price
	end
	
	def buy_x_get_y_free_products(total, buy, get)
		group_size = buy + get
		return 0 if total < group_size

		groups = total / group_size
		remainder = total % group_size

		free_from_groups = groups * get
		
		addinitonal_free_products = 0
		if remainder > buy
			addinitonal_free_products = remainder - buy
		end

		total = free_from_groups + addinitonal_free_products
	end
end
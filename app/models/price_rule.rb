PriceRule = Struct.new(:id, :product_code, :type, :quantity, :amount) do
end

# Type: product_discount, quantity: 1, amount: 1 => buy one get one
# Type: product_discount, quantity: 2, amount: 1 => buy 2 get one
# Type: product_discount, quantity: 5, amount: 1 Buy five get one

# Type: cash_discount, quantity: 2, amount: 50 => Buy 2 get 50$ discount
# Type: cash_discount, quantity: 4, amount: 70 => Buy 2 get 70$ cash discount
# Type: cash_discount, quantity: 6, amount: 100 => Buy 6 get 100 cash discount

# Type: percentage_discount, quantity: 5, amount: 20 => Buy 5 get 20% discount
# Type: cash_discount, quantity: 10, amount: 30 => Buy 10 get 30% discount
# Type: cash_discount, quantity: 15, amount: 40 => Buy 15 get 40$ discount

# Supported types:
	# product_discount
	# cash_discount
	# percentage_discount
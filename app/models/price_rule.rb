PriceRule = Struct.new(:id, :product_code, :type, :quantity, :amount) do
end

# Supported types:
	# product_discount
	# cash_discount
	# percentage_discount
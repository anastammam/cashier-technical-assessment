PriceRule = Struct.new(:id, :product_code, :type, :quantity, :amount) do
  def initialize(id = nil, product_code = '', type = '', quantity = 0, amount = 0)
    super(id || SecureRandom.uuid, product_code, type, quantity, amount)
  end
end

# Supported types:
  # product_discount
  # cash_discount
  # percentage_discount
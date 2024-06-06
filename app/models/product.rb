Product = Struct.new(:id, :code, :name, :price) do
  def initialize(id = nil, code = '', name = '', price = 0.0)
    super(id || SecureRandom.uuid, code, name, price)
  end
end
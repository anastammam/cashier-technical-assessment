require_relative 'price_rules'

class Checkout
  include PriceRules
  attr_accessor :products, :amount
  alias_method :basket, :products

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

  private

  def discount!
    return if @price_rules.empty? || @products.empty?

    @total_amount = @amount
    eligible_price_rules.each do |price_rule|
      send("#{price_rule[:type]}!", price_rule)
    end
  end

  def eligible_price_rules
    eligible_products_for_discount = @price_rules.map(&:product_code) & @products.map(&:code)
    return [] if eligible_products_for_discount.empty?

    @price_rules.select { |price_rule| eligible_products_for_discount.include?(price_rule[:product_code]) }
  end

end
require 'spec_helper'

describe Checkout do
  let(:green_tea_product) { Product.new(nil, "GR1", "Green tea", 3.11) }
  let(:strawberry_product) { Product.new(nil, "SR1", "Strawberry", 5.00) }
  let(:coffee_product) { Product.new(nil, "CF1", "Coffee", 11.23) }

  let(:price_rules) do
    [
      PriceRule.new(nil, "GR1", "product_discount", 1, 1),
      PriceRule.new(nil, "SR1", "cash_discount", 3, 0.5),
      PriceRule.new(nil, "CF1", "percentage_discount", 3, 0.6667)
    ]
  end
  
  subject { described_class.new(price_rules) }

  it "should scan products" do
    subject.scan(green_tea_product)
    subject.scan(coffee_product)

    expect(subject.basket[0]).to eq(green_tea_product)
    expect(subject.basket[1]).to eq(coffee_product)
  end

  it "should give the exact price" do
    subject.scan(green_tea_product)
    subject.scan(coffee_product)

    expect(subject.amount).to eq(14.340)
  end

  context "Discount" do
    it "should do percentage_discount" do
      subject.scan(coffee_product)
      subject.scan(coffee_product)
      subject.scan(coffee_product)
      subject.scan(coffee_product)

      expect(subject.total).to eq(29.95)
    end

    it "should do cash_discount" do
      subject.scan(strawberry_product)
      subject.scan(strawberry_product)
      subject.scan(strawberry_product)

      expect(subject.total).to eq(13.5)
    end

    it "should do product_discount" do
      subject.scan(green_tea_product)
      subject.scan(green_tea_product)
      subject.scan(green_tea_product)

      expect(subject.total).to eq(6.22)
    end
  end

  context "Random products with discount" do
    # GR1,CF1,SR1,CF1,CF1
    it "should do percentage discount & product discount" do
      subject.scan(green_tea_product)
      subject.scan(coffee_product)
      subject.scan(strawberry_product)
      subject.scan(coffee_product)
      subject.scan(coffee_product)

      expect(subject.total).to eq(30.57)
    end

    # SR1,SR1,GR1,SR1
    it "should do cash discount" do
      subject.scan(strawberry_product)
      subject.scan(strawberry_product)
      subject.scan(green_tea_product)
      subject.scan(strawberry_product)

      expect(subject.total).to eq(16.61)
    end

    # GR1,SR1,GR1,GR1,CF1
    it "should do product discount" do 
      subject.scan(green_tea_product)
      subject.scan(strawberry_product)
      subject.scan(green_tea_product)
      subject.scan(green_tea_product)
      subject.scan(coffee_product)
    
      expect(subject.total).to eq(22.45)
    end

    # GR1,GR1
    it "should do product_discount" do
      subject.scan(green_tea_product)
      subject.scan(green_tea_product)

      expect(subject.total).to eq(3.11)
    end
  end
end
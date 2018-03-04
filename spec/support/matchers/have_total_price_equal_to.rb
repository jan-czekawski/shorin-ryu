require 'rspec/expectations'

RSpec::Matchers.define :have_total_price_equal_to do |sum|
  match do |cart| 
    expect(cart.sum_price).to eq sum
  end

  failure_message do
    "#{cart.sum_price} expected to be equal to #{sum}"
  end

  failure_message_when_negated do
    "#{cart.sum_price} expected not to be equal to #{sum}"
  end

  description do
    "check if cart's total price is"
  end
end
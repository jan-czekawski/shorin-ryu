module HaveTotalPriceEqualTo
  class HaveTotalPriceEqualTo
    def initialize(sum)
      @sum = sum
    end
    
    def matches?(cart)
      @cart = cart
      @cart.sum_price == @sum
    end
    
    def failure_message
      "#{@cart.sum_price} expected to be equal to #{@sum}"
    end
    
    def failure_message_when_negated
      "#{@cart.sum_price} expected not to be equal to #{@sum}"
    end
    
    def description
      "check if cart's total price is"
    end
  end
  
  def have_total_price_equal_to(price)
    HaveTotalPriceEqualTo.new(price)
  end
  
end
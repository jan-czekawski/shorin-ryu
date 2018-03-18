class CheckoutAddress
  attr_reader :city, :street, :house_number, :zip_code
  
  def initialize(city, street, house_number, zip_code)
    @city = city
    @street = street
    @house_number = house_number
    @zip_code = zip_code
  end
  
  def mongoize
    [city, street, house_number, zip_code]
  end
  
  class << self
    
    def demongoize(object)
      CheckoutAddress.new(object[0], object[1], object[2], object[3])
    end
    
    def mongoize(object)
      case object
      when CheckoutAddress
        object.mongoize
      when Hash
        CheckoutAddress.new(object[:city], object[:street],
                            object[:house_number], object[:zip_code])
                       .mongoize
      else
        object
      end
    end
    
    def evolve(object)
      case object
      when CheckoutAddress
        object.mongoize
      else
        object
      end
    end
  end
end
require 'rails_helper'

RSpec.describe Event, type: :model do
  describe Event, ".new" do
    
    it "creates valid event" do
      event = build(:event)
      expect(event).to be_valid
    end
    
    it "requires name" do
      event = build(:event, name: nil)
      expect(event).not_to be_valid
    end
  
    it "requires address" do
      event = build(:event)
      event.address = nil
      expect(event).not_to be_valid
    end
    
  end
end

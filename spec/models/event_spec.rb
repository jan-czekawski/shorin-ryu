require 'rails_helper'

RSpec.describe Event, type: :model do
  describe Event, ".new" do
    
    after(:all) do
      User.delete_all
    end
    
    it "creates valid event" do
      user = create(:user, email: "event@associate.com", login: "event")
      event = build(:event, user_id: user.id)
      expect(event).to be_valid
    end
    
    it "requires name" do
      event = build(:event, user_id: 1, name: nil)
      expect(event).not_to be_valid
    end
  
    it "requires address" do
      event = build(:event, user_id: 1, address: nil)
      expect(event).not_to be_valid
    end
    
  end
end

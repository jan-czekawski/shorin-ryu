require 'rails_helper'

RSpec.describe User, type: :model do
  describe User, ".new" do
    
    it "creates new user if all info is provided" do
      # setup
      old_count = User.all.count
      
      # exercise
      User.create(email: "user@email.com", password: "password")
      new_count = User.all.count
      
      # verify
      expect(new_count).to eq old_count + 1
      
      # teardown
      User.all.delete_all
    end
  
  end
end

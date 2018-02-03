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
    
    it "makes user invalid unless email is present" do
      user = User.create(password: "password")
      
      expect(user.valid?).to be_falsy
    end
    
    it "makes user invalid unless password is present" do
      user = User.create(email: "email@email.com")
      
      expect(user.valid?).to be_falsy
    end
  
  end
end

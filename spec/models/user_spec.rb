require 'rails_helper'

RSpec.describe User, type: :model do
  describe User, ".new" do
    
    after(:all) do
      User.delete_all
    end
    
    it "creates new user if all info is provided" do
      # setup
      old_count = User.all.count
      
      # exercise
      User.create(email: "user@email.com", password: "password")
      new_count = User.all.count
      
      # verify
      expect(new_count).to eq old_count + 1
      
      # teardown
      # User.delete_all
    end
    
    it "makes user invalid unless email is present" do
      user = User.create(password: "password")
      
      expect(user.valid?).to be_falsy
    end
    
    it "makes user invalid unless password is present" do
      user = User.create(email: "email@email.com")
      
      expect(user.valid?).to be_falsy
    end
    
    it "requires unique email address" do
      first_user_info = { email: "first@email.com", password: "password"}
      User.create(first_user_info)
      
      second_user = User.create(first_user_info)
      
      expect(second_user.valid?).to be_falsy
    end
    
    it "makes admin false by default" do
      user = User.create(email: "some@email.com", password: "password")
      
      expect(user.admin).to be false
    end
  
  end
end

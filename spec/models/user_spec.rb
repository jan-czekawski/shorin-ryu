require 'rails_helper'

RSpec.describe User, type: :model do
  describe User, ".new" do
    
    after(:each) do
      User.delete_all
    end
    
    it "creates new user if all info is provided" do
      # setup
      # old_count = User.all.count
      
      # exercise
      user = User.create(email: "user@email.com", password: "password")
      # new_count = User.all.count
      
      # verify
      # expect(new_count).to eq old_count + 1
      # expect(User.last).to eq user
      # expect(user.valid?).to be true
      expect(user).to be_valid
      
      # teardown
      # User.delete_all
    end
    
    it "requires that email is present" do
      user = User.create(password: "password")
      
      # expect(user.valid?).to be false
      expect(user).not_to be_valid
    end
    
    it "requires that password is present" do
      user = User.create(email: "email@email.com")
      
      # expect(user.valid?).to be false
      expect(user).not_to be_valid
    end
    
    let(:first_user) do 
      @first_user_info = { email: "first@email.com", password: "password" }
      User.create(@first_user_info)
    end
    
    it "requires unique email address" do
      # first_user_info = { email: "first@email.com", password: "password" }
      # User.create(first_user_info)
      first_user
      second_user = User.create(@first_user_info)

      # expect(second_user.valid?).to be false
      expect(second_user).not_to be_valid
    end
    
    it "confirms case insensitivity with email uniqueness" do
      # first_user_info = { email: "first@email.com", password: "password" }
      # User.create(first_user_info)
      first_user
      
      second_user_info = @first_user_info.each { |k, v| v.upcase! if k == :email }
      second_user = User.create(second_user_info)    
      
      # expect(second_user.valid?).to be false
      expect(second_user).not_to be_valid
    end
    
    it "requires email with correct format" do
      incorrect_emails = ["email.email.com", "@email.com", "email@email"]
      users = []
      
      incorrect_emails.each_with_index do |adr, ix|
        users << ix = User.create(email: adr, password: "password")
      end
      
      users.each { |usr| expect(usr).not_to be_valid }
    end
    
    it "assigns false to admin attr by default" do
      user = User.create(email: "some@email.com", password: "password")
      
      # expect(user.admin).to be false
      expect(user).not_to be_admin
    end
  
  end
end

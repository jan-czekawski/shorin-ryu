require 'rails_helper'

RSpec.describe User, type: :model do
  describe User, ".new" do

    # let(:build_correct_user) do
    #   user = User.new(email: "user@email.com", password: "password")
    # end

    it "creates new user if all info is provided" do
      # setup
      # old_count = User.all.count

      # exercise
      # user = build_correct_user
      user = build(:user)
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
      user = build(:user, email: nil)
      # expect(user.valid?).to be false
      expect(user).not_to be_valid
    end

    it "requires that login is present" do
      user = build(:user, login: nil)
      # expect(user.valid?).to be false
      expect(user).not_to be_valid
    end

    it "requires email to have correct format" do
      incorrect_emails = ["email.email.com", "@email.com", "email@email"]
      users = []
      
      incorrect_emails.each_with_index do |adr, ix|
        users << build(:user, email: adr, password: "password")
      end
      users.each { |usr| expect(usr).not_to be_valid }
    end

    it "requires that password is present" do
      user = build(:user, password: nil)
      # expect(user.valid?).to be false
      expect(user).not_to be_valid
    end

    it "requires password to have min 6 chars" do
      user = build(:user, password: "a" * 5)
      expect(user).not_to be_valid
    end

    it "assigns false to admin attr by default" do
      user = build(:user)
      # expect(user.admin).to be false
      expect(user).not_to be_admin
    end

    context "when email already exists" do
      it "requires unique email address" do
        # first_user_info = { email: "first@email.com", password: "password" }
        # User.new(first_user_info)
        create(:user, email: "chandler@email.com", login: "chandler_1")
        user = build(:user, email: "chandler@email.com", login: "chandler_2")
        # second_user = User.new(email: "user@email.com", password: "password")
        # second_user = build_correct_user
        # p second_user, user
        # expect(second_user.valid?).to be false
        expect(user).not_to be_valid
      end

      it "confirms case insensitivity with email uniqueness" do
        # first_user_info = { email: "first@email.com", password: "password" }
        # User.new(first_user_info)
        # user = User.create(email: "second_user@email.com",
        # password: "password")
        create(:user, email: "ross@email.com", login: "ross_1")
        user = build(:user, email: "ROSS@email.com", login: "ross_2")
        # @second_user.email = user.email.upcase
        # second_user_info = @first_user_info.each do
        # |k, v| v.upcase! if k == :email
        # end
        # second_user = User.new(second_user_info)
        # expect(second_user.valid?).to be false
        expect(user).not_to be_valid
      end
    end

    context "when login already exists" do
      it "requires unique login" do
        create(:user, email: "joe@email.com", login: "joe")
        user = build(:user, email: "joseph@email.com", login: "joe")
        expect(user).not_to be_valid
      end

      it "confirms case insensitivity with email uniqueness" do
        create(:user, email: "phil@email.com", login: "phil")
        user = build(:user, email: "phillip@email.com", login: "PHIL")
        expect(user).not_to be_valid
      end
    end
  end
end

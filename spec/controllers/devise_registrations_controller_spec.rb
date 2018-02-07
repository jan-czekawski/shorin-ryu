require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
  
  before(:all) do
    User.delete_all
  end
  
  after(:all) do
    User.delete_all
  end
  
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe "Devise::RegistrationsController#create" do
    it "creates new user if valid information is provided", :dev do
      # expect do
      #   post :create, params: { user: { email: "first_devise@emailcom",
      #                                   password: "password",
      #                                   password_confirmation: "password" } }
      # end.to change(User, :count).by(1)
      expect do
        User.create(email: "devise@email.com",
                    password: "password",
                    password_confirmation: "password")
      end.to change(User, :count).by(1)
    end
  end
end

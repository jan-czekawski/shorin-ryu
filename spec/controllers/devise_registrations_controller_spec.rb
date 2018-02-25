require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
  
  after(:all) do
    User.delete_all
  end
  
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe "Devise::RegistrationsController#create" do
    it "creates new user if valid information is provided" do
      expect do
        post :create, params: { user: attributes_for(:user) }
      end.to change(User, :count).by(1)
    end
  end
end

require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
  
  after(:all) do
    User.delete_all
  end
  
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe "RegistrationsController#new" do
    context "when user not logged in" do
      it "assigns new user to @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
      
      it "renders new user show template" do
        get :new
        expect(response).to render_template :new
      end
    end
    
    context "when user logged in" do
      it "redirects to root url" do
        sign_in create(:user)
        get :new
        expect(response).to redirect_to(root_url)
      end
    end
  end
  
  describe "RegistrationsController#edit" do
  end
  
  describe "RegistrationsController#create" do
    context "with valid information" do
      it "increases users count by 1" do
        expect do
          post :create, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end
      
      it "redirects to root after save" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(root_url)
      end
    end
    
    context "with invalid information" do
      it "doesn't change users count" do
        expect do
          post :create, params: { user: attributes_for(:user, email: nil) }
        end.not_to change(User, :count)
      end
      
      it "renders template 'new'" do
        post :create, params: { user: attributes_for(:user, email: nil) }
        expect(response).to render_template("new")
      end
    end
  end
end

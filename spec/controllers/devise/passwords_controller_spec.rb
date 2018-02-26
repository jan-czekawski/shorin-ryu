require "rails_helper"

RSpec.describe Devise::PasswordsController, type: :controller do
  after(:all) do
    User.delete_all
  end
  
  before(:all) do
    @user = create(:user)
  end
  
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe "#new" do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in @user
        get :new
        expect(response).to redirect_to root_url
      end
    end
    
    context "when user not logged in" do
      it "renders new template" do
        get :new
        expect(response).to render_template :new
      end
      
      it "assigns new user to @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
  
  describe "#create", :new do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in @user
        post :create, params: { user: { email: @user.email } }
        expect(response).to redirect_to root_url
      end
    end
    
    context "when user not logged in" do
      it "redirects to login url after password reset" do
        post :create, params: { user: { email: @user.email } }
        expect(response).to require_login
      end
      
      it "assigns new password token to @user" do
        post :create, params: { user: { email: @user.email } }
        expect(@user.reload.reset_password_token).not_to be_nil
      end
      
      it "assigns current time to password reset sent at of @user" do
        post :create, params: { user: { email: @user.email } }
        sent_at = @user.reload.reset_password_sent_at
        expect(sent_at).to be_within(1.second).of Time.now
      end
    end
  end
end
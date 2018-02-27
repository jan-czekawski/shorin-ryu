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
  
  describe "#create" do
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
      
      it "assigns unique password token to @user" do
        post :create, params: { user: { email: @user.email } }
        first_reset_token = @user.reload.reset_password_token
        # post :create, params: { user: { email: @user.email } }
        second_reset_token = @user.reload.reset_password_token
        expect(second_reset_token).not_to be eq first_reset_token
        # TODO: fix unique password token
      end
      
      it "assigns current time to password reset sent at of @user" do
        post :create, params: { user: { email: @user.email } }
        sent_at = @user.reload.reset_password_sent_at
        expect(sent_at).to be_within(1.second).of Time.now
      end
    end
  end
  
  describe "#edit" do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in @user
        @user.reset_password_token = "random_token"
        get :edit, params: { reset_password_token: @user.reset_password_token }
        expect(response).to redirect_to root_url
      end
    end
    
    context "when user not logged in" do
      before(:all) do
        @user.reset_password_token = "random_token"
        @token = @user.reset_password_token
      end

      it "renders edit template" do
        get :edit, params: { reset_password_token: @token }
        expect(response).to render_template :edit
      end
      
      it "assigns new instance of User to @user" do
        get :edit, params: { reset_password_token: @token }
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
  
  describe "#update", :new do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in @user
        @token = @user.send_reset_password_instructions
        put :update, params: { reset_password_token: @token,
                                 user: { password: "new_pass1",
                                         password_confirmation: "new_pass1" } }
        expect(response).to redirect_to root_url
      end
    end
    
    context "when user not logged in" do
      describe "with valid information" do
        it "updates users password" do
          @token = @user.send_reset_password_instructions
          put :update, params: { user: { reset_password_token: @token,
                                         password: "new_pass2",
                                         password_confirmation: "new_pass2" } }
          expect(password_changed?(@user, "new_pass2")).to be true
        end
        
        it "redirects to root after password reset" do
          @token = @user.send_reset_password_instructions
          put :update, params: { user: { reset_password_token: @token,
                                         password: "new_pass3",
                                         password_confirmation: "new_pass3" } }
          expect(response).to redirect_to root_url
        end
        
        it "signs user in after password reset" do
          @token = @user.send_reset_password_instructions
          put :update, params: { user: { reset_password_token: @token,
                                         password: "new_pass4",
                                         password_confirmation: "new_pass4" } }
          expect(session["warden.user.user.key"]).not_to be_nil
        end
      end
      
      describe "with invalid information" do
        it "doesn't update user's password" do
          @token = @user.send_reset_password_instructions
          put :update, params: { user: { reset_password_token: nil,
                                         password: "new_pass5",
                                         password_confirmation: "new_pass5" } }
          expect(password_changed?(@user, "new_pass5")).not_to be true
        end
      end
    end
  end
  
  def password_changed?(user, password)
    Devise::Encryptor.compare(User, user.reload.encrypted_password, password)
  end
end
require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
  before(:each) { @request.env["devise.mapping"] = Devise.mappings[:user] }

  before(:all) { @user = create(:user) }

  describe "#new" do
    context "when user not logged in" do
      it "assigns new user to @user" do
        get :new
        expect(assigns(:user)).to be_a_new User
      end

      it "renders new user show template" do
        get :new
        expect(response).to render_template :new
      end
    end

    context "when user logged in" do
      it "redirects to root url" do
        sign_in @user
        get :new
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "#edit" do
    context "when user not logged in" do
      it "redirects to sign in url" do
        get :edit
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      it "assigns logged in user to @user" do
        sign_in @user
        get :edit
        expect(assigns(:user)).to eq @user
      end

      it "renders edit template" do
        sign_in @user
        get :edit
        expect(response).to render_template :edit
      end
    end
  end

  describe "#create" do
    context "with valid information" do
      it "increases users count by 1" do
        expect do
          post :create, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it "redirects to root after save" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to root_url
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
        expect(response).to render_template :new
      end
    end
  end

  describe "#update" do
    context "when user not logged in" do
      it "redirects to sign in url" do
        patch :update, params: { user: { email: @user.email,
                                         current_password: @user.password } }
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      before(:each) do
        sign_in @user
        @another_user = build(:user)        
      end

      describe "with valid information" do
        it "updates user's attributes" do
          patch :update, params: { user: { email: @another_user.email,
                                           current_password: @user.password } }
          expect(@user.reload).to have_same_email_as @another_user
        end

        it "redirects to root page after updating" do
          patch :update, params: { user: { email: @another_user.email,
                                           current_password: @user.password } }
          expect(response).to redirect_to root_url
        end
      end

      describe "with invalid information" do
        it "doesn't update user's attributes" do
          patch :update, params: { user: { email: @another_user.email,
                                           current_password: "invalid" } }
          expect(@user.reload).not_to have_same_email_as @another_user
        end

        it "renders edit template after failed update" do
          patch :update, params: { user: { email: @another_user.email,
                                           current_password: "invalid" } }
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "doesn't change User count" do
        expect { delete :destroy }.not_to change(User, :count)
      end

      it "redirects to login page after failed delete" do
        delete :destroy
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      it "decreases User count by 1" do
        sign_in @user
        expect { delete :destroy }.to change(User, :count).by(-1)
      end

      it "redirects to root page after delete" do
        @user = create(:user)
        sign_in @user
        delete :destroy
        expect(response).to redirect_to root_url
      end

      it "logs out the deleted user" do
        @user = create(:user)
        sign_in @user
        delete :destroy
        expect(session).not_to be_logged_in
      end
    end
  end
end

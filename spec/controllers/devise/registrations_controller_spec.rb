require 'rails_helper'

RSpec.describe Devise::RegistrationsController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#new" do
    context "when user not logged in" do
      it "renders new user show template and assigns new user to @user" do
        get :new
        expect(response).to render_template :new
        expect(assigns(:user)).to be_a_new User
      end
    end

    context "when user logged in" do
      it "redirects to root url" do
        sign_in create(:user)
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
      it "renders edit template and assigns logged in user to @user" do
        user = create(:user)
        sign_in user
        get :edit
        expect(response).to render_template :edit
        expect(assigns(:user)).to eq user
      end
    end
  end

  describe "#create" do
    context "when user logged in" do
      it "doesn't change users count and redirects to root url" do
        sign_in create(:user)
        expect do
          post :create, params: { user: attributes_for(:user) }
        end.not_to change(User, :count)
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in" do
      describe "with valid information" do
        it "increases users count by 1 and redirects to root url" do
          expect do
            post :create, params: { user: attributes_for(:user) }
          end.to change(User, :count).by(1)
          expect(response).to redirect_to root_url
        end
      end

      describe "with invalid information" do
        it "doesn't change users count and renders template 'new'" do
          expect do
            post :create, params: { user: attributes_for(:user, email: nil) }
          end.not_to change(User, :count)
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "#update" do
    context "when user not logged in" do
      it "redirects to sign in url" do
        user = create(:user)
        patch :update, params: { user: { email: user.email,
                                         current_password: user.password } }
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      describe "with valid information" do
        it "updates user's attributes and redirects to root url" do
          user = create(:user)
          another_user = build(:user)
          sign_in user
          patch :update, params: { user: { email: another_user.email,
                                           current_password: user.password } }
          expect(user.reload).to have_same_email_as another_user
          expect(response).to redirect_to root_url
        end
      end

      describe "with invalid information" do
        it "doesn't update user's attributes and renders edit template" do
          user = create(:user)
          another_user = build(:user)
          sign_in user
          patch :update, params: { user: { email: another_user.email,
                                           current_password: "invalid" } }
          expect(user.reload).not_to have_same_email_as another_user
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "doesn't change User count and redirects to login page" do
        expect do
          delete :destroy
        end.not_to change(User, :count)
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      it "decreases User count by 1 and redirects to root url" do
        sign_in create(:user)
        expect do
          delete :destroy
        end.to change(User, :count).by(-1)
        expect(response).to redirect_to root_url
      end

      it "logs out the deleted user" do
        sign_in create(:user)
        delete :destroy
        expect(session).not_to be_logged_in
      end
    end
  end
end

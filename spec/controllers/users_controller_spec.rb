require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#index" do
    context "when user not logged in" do
      it "redirects to root" do
        get :index
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      it "renders index template and populates array of all users" do
        user = create(:user)
        another_user = create(:user)
        sign_in user
        get :index
        expect(response).to render_template :index
        expect(assigns(:users)).to include(another_user, user)
      end
    end
  end

  describe "#show" do
    context "when user not logged in" do
      it "redirects to login page" do
        user = create(:user)
        get :show, params: { id: user.id }
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      it "renders show template and assigns selected user to @user" do
        user = create(:user)
        sign_in user
        get :show, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
        expect(response).to render_template :show
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "redirects to login page" do
        user = create(:user)
        expect do
          delete :destroy, params: { id: user.id }
        end.not_to change(User, :count)
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      context "and not admin" do
        it "doesn't change user count and redirects to root" do
          user = create(:user)
          another_user = create(:user)
          sign_in another_user
          expect do
            delete :destroy, params: { id: user.id }
          end.not_to change(User, :count)
          expect(response).to require_admin
        end
      end
      
      context "and admin" do
        it "deletes other user and redirects to users path" do
          user = create(:user)
          sign_in create(:admin)
          expect do
            delete :destroy, params: { id: user.id }
          end.to change(User, :count).by(-1)
          expect(response).to redirect_to users_path
        end
      end
    end
  end
end

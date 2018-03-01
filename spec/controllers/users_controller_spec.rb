require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:all) do
    @james = create(:user, email: "james@email.com", login: "james")
    @phil = create(:user, email: "phil@email.com", login: "phil")
    @admin = create(:admin, email: "admin@email.com", login: "admin_controller")
  end

  describe "#index" do
    context "when user not logged in" do
      it "redirects to root" do
        get :index
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      before(:each) { sign_in @james }

      it "populates array of all users" do
        get :index
        expect(assigns(:users)).to match_array([@phil, @james, @admin])
      end

      it "renders index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "#show" do
    context "when user not logged in" do
      it "redirects to login page" do
        get :show, params: { id: @james.id }
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when user logged in" do
      before(:each) { sign_in @james }

      it "assigns requested user to @user" do  
        get :show, params: { id: @james.id }
        expect(assigns(:user)).to eq(@james)
      end

      it "renders show template" do
        get :show, params: { id: @james.id }
        expect(response).to render_template :show
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "redirects to login page" do
        expect do
          delete :destroy, params: { id: @james.id }
        end.not_to change(User, :count)

        expect(response).to require_login
      end
    end

    context "when user logged in, but not admin" do
      before(:each) { sign_in @phil }

      it "doesn't change user count" do
        expect do
          delete :destroy, params: { id: @james.id }
        end.not_to change(User, :count)
      end

      it "redirects to root" do
        delete :destroy, params: { id: @james.id }
        expect(response).to require_admin
      end
    end

    context "when user logged in and admin" do
      before(:each) { sign_in @admin }

      it "deletes other user" do
        expect do
          delete :destroy, params: { id: @james.id }
        end.to change(User, :count).by(-1)
      end

      it "redirects to users index" do
        delete :destroy, params: { id: @james.id }
        expect(response).to redirect_to users_path
      end
    end
  end
end

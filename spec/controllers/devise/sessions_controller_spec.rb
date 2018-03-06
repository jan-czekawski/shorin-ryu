require "rails_helper"

RSpec.describe Devise::SessionsController, type: :controller do
  before(:each) { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "#new" do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in create(:user)
        get :new
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in" do
      it "renders new template and assigns new User to @user" do
        get :new
        expect(response).to render_template :new
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe "#create" do
    context "when user logged in" do
      it "redirects to root url" do
        user = create(:user)
        sign_in user
        post :create, params: { user: { email: user.email,
                                        password: user.password } }
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in" do
      describe "with valid information" do
        it "redirects to root url and signs user in" do
          user = create(:user)
          post :create, params: { user: { email: user.email,
                                          password: user.password } }
          expect(response).to redirect_to root_url
          expect(session).to be_logged_in
        end
      end

      describe "with invalid information" do
        it "renders new template and doesn't sign user in" do
          user = create(:user)
          post :create, params: { user: { email: user.email,
                                          password: "invalid" } }
          expect(response).to render_template :new
          expect(session).not_to be_logged_in
        end
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "redirects to root url" do
        delete :destroy
        expect(response).to redirect_to root_url
      end
    end

    context "when user logged in" do
      it "redirects to root url and signs user out" do
        sign_in create(:user)
        delete :destroy
        expect(response).to redirect_to root_url
        expect(session).not_to be_logged_in
      end
    end
  end
end

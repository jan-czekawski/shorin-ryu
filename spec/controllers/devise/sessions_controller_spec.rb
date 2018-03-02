require "rails_helper"

RSpec.describe Devise::SessionsController, type: :controller do
  after(:all) { User.delete_all }

  before(:all) { @user = create(:user) }

  before(:each) { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "#new" do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in @user
        get :new
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in" do
      it "assigns new User to @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it "renders new template" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "#create" do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in @user
        post :create, params: { user: { email: @user.email,
                                        password: @user.password } }
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in" do
      describe "with valid information" do
        it "redirects to root url after session's created" do
          post :create, params: { user: { email: @user.email,
                                          password: @user.password } }
          expect(response).to redirect_to root_url
        end

        it "signs user in" do
          post :create, params: { user: { email: @user.email,
                                          password: @user.password } }
          expect(session).to be_logged_in
        end
      end

      describe "with invalid information" do
        it "renders new template" do
          post :create, params: { user: { email: @user.email,
                                          password: "invalid" } }
          expect(response).to render_template :new
        end

        it "doesn't sign user in" do
          post :create, params: { user: { email: @user.email,
                                          password: "invalid" } }
          expect(session).not_to be_logged_in
        end
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "redirects to root url after failed logging out" do
        delete :destroy
        expect(response).to redirect_to root_url
      end
    end

    context "when user logged in" do
      it "redirects to root url after logging out" do
        sign_in @user
        delete :destroy
        expect(response).to redirect_to root_url
      end

      it "signs user out" do
        sign_in @user
        delete :destroy
        expect(session).not_to be_logged_in
      end
    end
  end
end

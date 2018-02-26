require "rails_helper"

RSpec.describe Devise::SessionsController, type: :controller do
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
          expect(session["warden.user.user.key"]).not_to be_nil
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
          expect(session["warden.user.user.key"]).to be_nil
        end
      end
    end
  end
end
require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:all) do
    @james = create(:user, email: "james@email.com", login: "james")
    @phil = create(:user, email: "phil@email.com", login: "phil")
    @admin = create(:admin, email: "admin@email.com", login: "admin_controller")
  end
  
  describe "Users#index" do
    context "when user not logged in" do
      it "redirects to root" do
        get :index
        expect(response).to require_login
      end
    end
    
    context "when user logged in" do
      it "populates array of all users" do
        sign_in @james
        get :index
        expect(assigns(:users)).to match_array([@phil, @james, @admin])
      end
      
      it "renders index template" do
        sign_in @james
        get :index
        expect(response).to render_template :index
      end
    end
  end
  
  describe "Users#show" do
    it "assigns requested user to @user" do
      get :show, params: { id: @james.id }
      expect(assigns(:user)).to eq(@james)
    end
    
    it "renders show template" do
      get :show, params: { id: @james.id }
      expect(response).to render_template :show
    end
  end
  
  describe "Users#destroy" do
    context "when user not logged in" do
      it "redirects to root" do
        expect do
          delete :destroy, params: { id: @james.id }
        end.not_to change(User, :count)
  
        expect(response).to require_login
      end
    end
    
    context "when user logged in, but not admin" do
      it "redirects to root" do
        sign_in @phil
        
        expect do
          delete :destroy, params: { id: @james.id }
        end.not_to change(User, :count)
        
        expect(response).to require_admin
      end
    end
    
    context "when user logged in and admin" do
      it "deletes other user" do
        sign_in @admin
        
        expect do
          delete :destroy, params: { id: @james.id }
        end.to change(User, :count).by(-1)
        
        expect(response).to redirect_to(users_path)
      end
    end
  end
end

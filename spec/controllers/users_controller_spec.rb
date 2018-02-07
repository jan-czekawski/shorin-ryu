require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  before(:all) do
    @user = create(:user, email: "controller@email.com")
    @second_user = create(:user, email: "second_controller@email.com")
    @admin = create(:admin, email: "admin@email.com")
    @count = User.count
  end
  
  after(:all) do
    User.delete_all
  end
  
  describe "Users#index" do
    
    it "redirects to root unless user's logged in" do
      get :index
      expect(response).to redirect_to(root_path)
    end
    
    it "renders index template if user's logged in" do
      sign_in @user
      get :index
      # expect(response.status).to eq(200)
      expect(response).to render_template("index")
    end
  end
  
  describe "Users#show" do
    it "renders show template" do
      get :show, params: { id: @user.id }
      expect(response).to render_template("show")
    end
  end
  
  describe "Users#destroy" do
    it "redirects to root unless user's logged_in" do
      expect do
        delete :destroy, params: { id: @user.id }
      end.not_to change(User, :count)

      expect(response).to redirect_to(root_path)
    end
    
    it "redirects to root unless user's admin" do
      sign_in @second_user
      
      expect do
        delete :destroy, params: { id: @user.id }
      end.not_to change(User, :count)
      
      expect(response).to redirect_to(root_path)
    end
    
    it "deletes other user if logged user's admin", :delete do
      sign_in @admin
      
      expect do
        delete :destroy, params: { id: @user.id }
      end.to change(User, :count).by(-1)
      
      expect(response).to redirect_to(users_path)
    end
  end
end

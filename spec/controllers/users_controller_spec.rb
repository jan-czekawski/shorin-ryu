require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  before(:all) do
    @user = create(:user, email: "controller@email.com")
    @second_user = create(:user, email: "second_controller@email.com")
    @admin = create(:admin, email: "admin@email.com")
    @count = User.count
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
      delete :destroy, params: { id: @user.id }
      expect(response).to redirect_to(root_path)
      expect(User.count).to eq(@count)
    end
  end
end

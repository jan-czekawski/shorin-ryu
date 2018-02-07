require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "Users#index" do
    
    before(:all) do
      @user = create(:user, email: "controller@email.com")
    end
    
    it "redirects from index unless user's logged in" do
      get :index
      expect(response).to redirect_to(controller: "pages", action: "index")
    end
    
    it "renders index template if user's logged in" do
      sign_in @user
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template("index")
    end
  end
end

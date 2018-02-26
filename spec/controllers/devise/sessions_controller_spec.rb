require "rails_helper"

RSpec.describe Devise::SessionsController, type: :controller do
  after(:all) do
    User.delete_all
  end
  
  before(:all) do
    @john = create(:user, login: "john")
  end
  
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe "#new" do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in @john
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
end
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "Users#index" do
    it "redirects from index unless user logged in" do
      get :index
      expect(response).to redirect_to(controller: "pages", action: "index")
    end
  end
end

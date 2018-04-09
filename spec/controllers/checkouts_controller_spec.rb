require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  # TODO: set up checkouts controller
  describe "#new" do
    context "when user logged in" do
      it "renders new template and assigns new checkout instance to @checkout" do
        sign_in create(:user)
        get :new
        expect(response).to render_template :new
        # expect(assigns(:checkout)).to be_a_new Checkout
      end
    end
    
    context "when user not logged in" do
      it "redirects to login page" do
        get :new
        expect(response).to redirect_to new_user_session_url
      end
    end
  end

  describe "#edit" do
    # context "when user logged in" do
    #   it "renders edit template and assigns checkout to @checkout" do
    #     user = create(:user)
    #     sign_in user
    #     get :edit, params: { checkout: user.checkout }
    #     expect(response).to render_template :edit
    #     expect(assigns(:checkout)).to be_eq user.checkout    
    #   end
    # end

    context "when user not logged in" do
    end
  end
end

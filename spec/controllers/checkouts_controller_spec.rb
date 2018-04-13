require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  # TODO: set up checkouts controller
  describe "#new" do
    context "when user logged in" do
      it "renders new template and assigns new checkout instance to @checkout" do
        sign_in create(:user)
        get :new
        expect(response).to render_template :new
        # FIXME: @checkout should be filled
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
    context "when user logged in" do
      it "renders edit template and assigns checkout to @checkout" do
        user = create(:user)
        sign_in user
        checkout = create(:checkout, user: user)
        # p Checkout.first.id
        # TODO: confirm if checkouts is
        get :edit, params: { id: checkout.id }
        # expect(response).to render_template :edit
        # expect(assigns(:checkout)).to be_eq user.checkout.first
      end
    end

    context "when user not logged in" do
      it "redirects to login page" do
        user = create(:user)
        checkout = create(:checkout, user: user)
        get :edit, params: { id: checkout.id }
        expect(response).to require_login
      end
    end
  end

  describe "#show" do
    context "when user logged in" do
      it "renders show template and assigns checkout to @checkout" do
        user = create(:user)
        sign_in user
        checkout = create(:checkout, user: user)
        get :show, params: { id: checkout.id }
        expect(response).to render_template :show
        expect(assigns(:checkout)).to be_eq user.checkout.first
      end
    end

    context "when user not logged in" do
      it "redirects to login page" do
        user = create(:user)
        checkout = create(:checkout, user: user)
        get :show, params: { id: checkout.id }
        expect(response).to require_login
      end
    end
  end

  describe "#destroy" do
    context "when user logged in" do
      # TEMPORARY FIX
      it "deletes or empties user's checkout" do
        user = create(:user)
        sign_in user
        checkout = create(:checkout, user: user)
        delete :destroy, params: { id: checkout.id }
        expect(assigns(:checkout).cart_items.count).to be_eq 0
      end
    end

    context "when user not logged in" do
      it "redirects to login page and doesn't empty user's checkout" do
        user = create(:user)
        checkout = create(:checkout, user: user)
        delete :destroy, params: { id: checkout.id }
        expect(assigns(:checkout).cart_items.count).not_to be_eq 0
        expect(response).to be require_login
      end
    end
  end
end

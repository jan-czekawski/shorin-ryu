require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  # TODO: set up checkouts controller
  describe "#new" do
    context "when user logged in" do
      it "renders new template and assigns new checkout instance to @checkout" do
        # FIXME: @checkout.cart_items should be fixed
        user = create(:user)
        sign_in user
        create(:cart, user: user)
        checkout = create(:checkout, user: user)
        cart_item = create(:cart_item, cart: user.cart)
        p user.cart.cart_items.count
        get :new
        p user.cart.cart_items.count
        expect(response).to render_template :new
        # p assigns(:checkout).cart_items.count
        # expect(assigns(:checkout).reload.cart_items.count).to eq 1
      end
    end

    context "when user not logged in" do
      it "redirects to login page" do
        get :new
        expect(response).to require_login
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
        expect(assigns(:checkout)).to eq user.checkouts.first
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
        create(:cart, user: user)
        checkout = create(:checkout, user: user)
        # TODO: move cart_items from checkout to cart
        cart_item = create(:cart_item, cart: user.cart, checkout: checkout)
        delete :destroy, params: { id: checkout.id }
        expect(checkout.cart_items.count).to eq 0
      end
    end

    context "when user not logged in" do
      it "redirects to login page and doesn't empty user's checkout" do
        user = create(:user)
        create(:cart, user: user)
        checkout = create(:checkout, user: user)
        # TODO: move cart_items from checkout to cart
        create(:cart_item, cart: user.cart, checkout: checkout)
        delete :destroy, params: { id: checkout.id }
        expect(checkout.cart_items.count).not_to eq 0
        expect(response).to require_login
      end
    end
  end
end

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  before(:all) do
    @user = create(:user)
    @admin = create(:admin)
    @item = create(:item)
  end

  after(:all) do
    User.delete_all
    Item.delete_all
  end

  describe "#index" do
    it "assigns array of all items to @items" do
      get :index
      expect(assigns(:items)).to match_array([@item])
    end

    it "renders index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    it "renders show template" do
      get :show, params: { id: @item.id }
      expect(response).to render_template :show
    end
  end

  describe "#new" do
    context "when user logged in" do
      describe "and admin" do
        before(:each) { sign_in @admin }

        it "renders new template" do
          get :new
          expect(response).to render_template :new
        end

        it "assigns new instance of Item to @item" do
          get :new
          expect(assigns(:item)).to be_a_new Item
        end
      end

      describe "and not admin" do
        it "redirect_to root url" do
          sign_in @user
          get :new
          expect(response).to redirect_to root_url
        end
      end
    end

    context "when user not logged in" do
      it "redirects to login page" do
        get :new
        expect(response).to require_login
      end
    end
  end

  describe "#create" do
    context "when user logged in" do
      describe "and admin" do
        before(:each) { sign_in @admin }

        context "with valid information" do
          it "increases item count by 1" do
            expect do
              post :create, params: { item: attributes_for(:item) }
            end.to change(Item, :count).by(1)
          end

          it "redirects to items path" do
            post :create, params: { item: attributes_for(:item) }
            expect(response).to redirect_to items_url
          end
        end

        context "with invalid information" do
          it "doesnt' change item count" do
            expect do
              post :create, params: { item: attributes_for(:item, name: nil) }
            end.not_to change(Item, :count)
          end

          it "renders new item template" do
            post :create, params: { item: attributes_for(:item, name: nil) }
            expect(response).to render_template :new
          end
        end
      end

      describe "and not admin" do
        before(:each) { sign_in @user }

        it "doesn't change item count" do
          expect do
            post :create, params: { item: attributes_for(:item) }
          end.not_to change(Item, :count)
        end

        it "redirects to root url" do
          post :create, params: { item: attributes_for(:item) }
          expect(response).to redirect_to root_url
        end
      end
    end

    context "when user not logged in" do
      it "doesn't change item count" do
        expect do
          post :create, params: { item: attributes_for(:item) }
        end.not_to change(Item, :count)
      end

      it "redirects to login page" do
        post :create, params: { item: attributes_for(:item) }
        expect(response).to require_login
      end
    end

    context "when user not logged in" do
      it "doesn't change item count" do
        expect do
          post :create, params: { item: attributes_for(:item) }
        end.not_to change(Item, :count)
      end

      it "redirects to login page" do
        post :create, params: { item: attributes_for(:item) }
        expect(response).to require_login
      end
    end
  end

  describe "#edit" do
    context "when user logged in" do
      describe "and admin" do
        before(:each) { sign_in @admin }

        it "renders edit template" do
          get :edit, params: { id: @item.id }
          expect(response).to render_template :edit
        end

        it "assigns item to @item" do
          get :edit, params: { id: @item.id }
          expect(assigns(:item)).to eq @item
        end
      end

      describe "and not admin" do
        before(:each) { sign_in @user }

        it "redirects to root url" do
          get :edit, params: { id: @item.id }
          expect(response).to redirect_to root_url
        end
      end
    end

    context "when user not logged in" do
      it "redirects to login page" do
        get :edit, params: { id: @item.id }
        expect(response).to require_login
      end
    end
  end

  describe "#update" do
    context "when user not logged in" do
      it "redirects to login page" do
        patch :update, params: { id: @item.id, item: attributes_for(:item) }
        expect(response).to require_login
      end

      it "doesn't update item's attributes" do
        old_item = @item
        patch :update, params: { id: old_item.id, item: attributes_for(:item) }
        expect(old_item.store_item_id).to eq @item.reload.store_item_id
      end
    end

    context "when user logged in" do
      describe "and not admin" do
        before(:each) { sign_in @user }

        it "redirects to root page" do
          patch :update, params: { id: @item.id, item: attributes_for(:item) }
          expect(response).to redirect_to root_url
        end

        it "doesn't update item's attributes" do
          old_item = @item
          patch :update, params: { id: old_item.id,
                                   item: attributes_for(:item) }
          expect(old_item.store_item_id).to eq @item.reload.store_item_id
        end
      end

      describe "and admin" do
        before(:each) { sign_in @admin }

        it "redirects to item path" do
          patch :update, params: { id: @item.id, item: attributes_for(:item) }
          expect(response).to redirect_to item_path(@item)
        end

        it "updates items attributes" do
          attributes = attributes_for(:item, store_item_id: 100)
          patch :update, params: { id: @item.id, item: attributes }
          expect(@item.reload.store_item_id).to eq 100
        end
      end
    end
  end

  describe "#delete" do
    context "when user not logged in" do
      it "doesn't change item count" do
        expect do
          delete :destroy, params: { id: @item.id }
        end.not_to change(Item, :count)
      end

      it "redirects to login page" do
        delete :destroy, params: { id: @item.id }
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      describe "and not admin" do
        before(:each) { sign_in @user }

        it "doestn't change item count" do
          expect do
            delete :destroy, params: { id: @item.id }
          end.not_to change(Item, :count)
        end

        it "redirects to root url" do
          delete :destroy, params: { id: @item.id }
          expect(response).to redirect_to root_url
        end
      end

      describe "and admin" do
        before(:each) { sign_in @admin }

        it "decreases item count by 1" do
          expect do
            delete :destroy, params: { id: @item.id }
          end.to change(Item, :count).by(-1)
        end

        it "redirects to items path" do
          item = create(:item)
          delete :destroy, params: { id: item.id }
          expect(response).to redirect_to items_path
        end
      end
    end
  end
end

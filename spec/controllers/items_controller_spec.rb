require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe "#index" do
    it "renders index template and assigns array of all items to @items" do
      item = create(:item)
      get :index
      expect(response).to render_template :index
      expect(assigns(:items)).to include(item)
    end
  end

  describe "#show" do
    it "renders show template and assigns selected item to @item" do
      item = create(:item)
      get :show, params: { id: item.id }
      expect(response).to render_template :show
      expect(assigns(:item)).to eq item
    end
  end

  describe "#new" do
    context "when user logged in" do
      context "and admin" do
        it "renders new template and assigns new instance of Item to @item" do
          sign_in create(:admin)
          get :new
          expect(response).to render_template :new
          expect(assigns(:item)).to be_a_new Item
        end
      end

      context "and not admin" do
        it "redirect_to root url" do
          sign_in create(:user)
          get :new
          expect(response).to require_admin
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
      context "and admin" do
        describe "with valid information" do
          it "increases item count by 1 and redirects to items_path" do
            sign_in create(:admin)
            expect do
              post :create, params: { item: attributes_for(:item) }
            end.to change(Item, :count).by(1)
            expect(response).to redirect_to items_url
          end
        end

        describe "with invalid information" do
          it "doesnt' change item count and renders template 'new'" do
            sign_in create(:admin)
            expect do
              post :create, params: { item: attributes_for(:item, name: nil) }
            end.not_to change(Item, :count)
            expect(response).to render_template :new
          end
        end
      end

      context "and not admin" do
        it "doesn't change item count and redirects to root url" do
          sign_in create(:user)
          expect do
            post :create, params: { item: attributes_for(:item) }
          end.not_to change(Item, :count)
          expect(response).to require_admin
        end
      end
    end

    context "when user not logged in" do
      it "doesn't change item count and redirects to login page" do
        expect do
          post :create, params: { item: attributes_for(:item) }
        end.not_to change(Item, :count)
        expect(response).to require_login
      end
    end
  end

  describe "#edit" do
    context "when user logged in" do
      context "and admin" do
        it "renders edit template and assigns selected item to @item" do
          item = create(:item)
          sign_in create(:admin)
          get :edit, params: { id: item.id }
          expect(response).to render_template :edit
          expect(assigns(:item)).to eq item
        end
      end

      context "and not admin" do
        it "redirects to root url" do
          item = create(:item)
          sign_in create(:user)
          get :edit, params: { id: item.id }
          expect(response).to require_admin
        end
      end
    end

    context "when user not logged in" do
      it "redirects to login page" do
        item = create(:item)
        get :edit, params: { id: item.id }
        expect(response).to require_login
      end
    end
  end

  describe "#update" do
    context "when user not logged in" do
      it "doesn't update item's attributes and redirects to login page" do
        item = create(:item, store_item_id: 100)
        new_attr = attributes_for(:item, store_item_id: 10)
        patch :update, params: { id: item.id,
                                 item: new_attr }
        item.reload
        expect(item.store_item_id).not_to eq 10
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      context "and not admin" do
        it "doesn't update item's attributes and redirects to root page" do
          item = create(:item, store_item_id: 200)
          new_attr = attributes_for(:item, store_item_id: 20)
          sign_in create(:user)
          patch :update, params: { id: item.id,
                                   item: new_attr }
          item.reload
          expect(item.store_item_id).not_to eq 20
          expect(response).to require_admin
        end
      end

      describe "and admin" do
        it "updates items attributes and redirects to item path" do
          item = create(:item, store_item_id: 300, name: "belt")
          new_attr = attributes_for(:item, store_item_id: 30, name: "kimono")
          sign_in create(:admin)
          
          patch :update, params: { id: item.id, item: new_attr }
          item.reload
          
          expect(item.store_item_id).to eq 30
          expect(item.name).to eq "kimono"
          expect(response).to redirect_to item_path(item)
        end
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "doesn't change item count and redirects to login page" do
        item = create(:item)
        expect do
          delete :destroy, params: { id: item.id }
        end.not_to change(Item, :count)
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      context "and not admin" do
        it "doestn't change item count and redirects to login page" do
          item = create(:item)
          sign_in create(:user)
          expect do
            delete :destroy, params: { id: item.id }
          end.not_to change(Item, :count)
          expect(response).to require_admin
        end
      end

      context "and admin" do
        it "decreases item count by 1 and redirects to items path" do
          item = create(:item)
          sign_in create(:admin)
          expect do
            delete :destroy, params: { id: item.id }
          end.to change(Item, :count).by(-1)
          expect(response).to redirect_to items_path
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

  before(:all) do
    @user = create(:user)
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

  describe "#new", :new do
    context "when user logged in" do
      
      before(:each) do
        sign_in @user
      end
      
      it "renders new template" do
        get :new
        expect(response).to render_template :new
      end
      
      it "assigns new instance of Item to @item" do
        get :new
        expect(assigns(:item)).to be_a_new Item
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
      it "returns http success" do
        # get :create
        # expect(response).to have_http_status(:success)
      end
    end
  end

  describe "#edit" do
    it "returns http success" do
      # get :edit, params: { id: @item.id }
      # expect(response).to have_http_status(:success)
    end
  end

  # describe "#update" do
  #   it "returns http success" do
  #     get :update
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "#delete" do
  #   it "returns http success" do
  #     get :delete
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end

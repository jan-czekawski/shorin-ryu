require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

  before(:all) do
    @item = create(:item)
  end
  
  after(:all) do
    Item.delete_all
  end

  describe "#index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "#show" do
    it "returns http success" do
      get :show, params: { id: @item.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "#new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  # describe "#create" do
  #   it "returns http success" do
  #     get :create
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  describe "#edit" do
    it "returns http success" do
      get :edit, params: { id: @item.id }
      expect(response).to have_http_status(:success)
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

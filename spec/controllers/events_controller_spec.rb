require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  
  before(:all) do
    @user = create(:user, email: "test@event.com")
    @admin = create(:admin, email: "admin@event.com")
    @example_event = create(:event, user_id: @user.id)
  end
  
  after(:all) do
    User.delete_all
    Event.delete_all
  end

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    it "returns http success" do
      get :show, params: { id: @example_event.id }
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "GET new" do
    it "returns http success" do
      sign_in @user
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "POST create" do
    it "creates new event if all info is provided" do
      sign_in @user
      expect do
        post :create, params: { event: { name: "Home",
                                         address: { city: "home_city",
                                                    street: "home street",
                                                    flat_number: 11,
                                                    zip_code: 200 } } }
      end.to change(Event, :count).by(1)
      expect(response).to redirect_to(events_path)
    end
    
    
    
    it "creates no event if all info is not provided" do
      sign_in @user
      expect do
        post :create, params: { event: { name: nil,
                                        address: { city: "home_city",
                                                    street: "home street",
                                                    flat_number: 11,
                                                    zip_code: 200 } } }
      end.not_to change(Event, :count)
      expect(response).to render_template("new")
    end
  end
  
  describe "GET edit" do
    it "returns http success" do
      get :edit, params: { id: @example_event.id }
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "PUT update" do
    it "updates info and redirects if correct info is provided" do
      put :update, params: { id: @example_event.id,
                             event: { name: "change_example",
                                      address: { city: "changed_city",
                                                 street: "changed_street",
                                                 flat_number: 666,
                                                 zip_code: 999 } } }
      @example_event.reload
      expect(@example_event.name).to eq("change_example")
      expect(@example_event.address[:city]).to eq("changed_city")
    end
  end

  describe "DELETE destroy" do
    it "doesn't delete event unless user's logged in" do
      sign_out @user if @user
      expect do
        delete :destroy, params: { id: @example_event.id }
      end.not_to change(Event, :count)
    end
    
    it "doesn't delete event unless user's logged in" do
      sign_in @user
      expect do
        delete :destroy, params: { id: @example_event.id }
      end.not_to change(Event, :count)
    end
    
    it "deletes event if user's logged in and is admin" do
      sign_in @admin
      expect do
        delete :destroy, params: { id: @example_event.id }
      end.to change(Event, :count).by(-1)
    end
  end
end

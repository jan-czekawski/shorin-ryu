require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  
  before(:all) do
    @example_event = create(:event)
  end
  
  after(:all) do
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
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  describe "POST create" do
    it "creates new event if all info is provided" do
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

end

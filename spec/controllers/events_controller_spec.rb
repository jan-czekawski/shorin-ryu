require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before(:all) do
    @john = create(:user, email: "john@event.com", login: "john")
    @paul = create(:user, email: "paul@event.com", login: "paul")
    @admin = create(:admin, email: "admin@event.com", login: "admin_event")
    @johns_event = create(:event, user_id: @john.id)
    @pauls_event = create(:event, user_id: @paul.id)
  end

  after(:all) do
    User.delete_all
    Event.delete_all
  end

  describe "#index" do
    it "assigns array of all events to @events" do
      get :index
      expect(assigns(:events)).to match_array([@johns_event, @pauls_event])
    end

    it "renders index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "#show" do
    it "assigns picked event to @event" do
      get :show, params: { id: @johns_event.id }
      expect(assigns(:event)).to eq @johns_event
    end

    it "renders show template" do
      get :show, params: { id: @johns_event.id }
      expect(response).to render_template :show
    end
  end

  describe "#new" do
    context "when user logged in" do
      before(:each) { sign_in @john }

      it "renders new template" do
        get :new
        expect(response).to render_template :new
      end

      it "assigns new instance of Event to @event" do
        get :new
        expect(assigns(:event)).to be_a_new Event
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
      before(:each) { sign_in @john }

      describe "with valid information" do
        it "creates new event" do
          address = attributes_for(:address)
          expect do
            post :create, params: { event: { name: "Home",
                                             address_attributes: address } }
          end.to change(Event, :count).by(1)
        end

        it "redirects to events path after creation" do
          address = attributes_for(:address)
          post :create, params: { event: { name: "Home",
                                           address_attributes: address } }
          expect(response).to redirect_to events_path
        end
      end

      describe "with invalid information" do
        it "doesn't create a new event" do
          address = attributes_for(:address)
          expect do
            post :create, params: { event: { name: nil,
                                             address_attributes: address } }
          end.not_to change(Event, :count)
        end

        it "renders new template after failed creation" do
          address = attributes_for(:address)
          post :create, params: { event: { name: nil,
                                           address_attributes: address } }
          expect(response).to render_template("new")
        end
      end
    end

    context "when user not logged in" do
      it "doesn't create a new event" do
        address = attributes_for(:address)
        expect do
          post :create, params: { event: { name: "random name",
                                           address_attributes: address } }
        end.not_to change(Event, :count)
      end

      it "redirects to login page" do
        address = attributes_for(:address)
        post :create, params: { event: { name: "random_name",
                                         address_attributes: address } }
        expect(response).to require_login
      end
    end
  end

  describe "#edit" do
    context "when user logged in" do
      describe "and admin" do
        before(:each) { sign_in @admin } 

        it "renders edit template" do
          get :edit, params: { id: @johns_event.id }
          expect(response).to render_template :edit
        end

        it "assigns picked event to @event" do
          get :edit, params: { id: @johns_event.id }
          expect(assigns(:event)).to eq @johns_event
        end
      end

      describe "and event's creator" do
        before(:each) { sign_in @john }

        it "renders edit template" do
          get :edit, params: { id: @johns_event.id }
          expect(response).to render_template :edit
        end

        it "assigns picked event to @event" do
          get :edit, params: { id: @johns_event.id }
          expect(assigns(:event)).to eq @johns_event
        end
      end

      describe "and not admin nor event's creator" do
        it "redirects to events_path" do
          sign_in @paul
          get :edit, params: { id: @johns_event.id }
          expect(response).to redirect_to(events_path)
        end
      end
    end

    context "when user not logged in" do
      it "redirects to login page" do
        get :edit, params: { id: @johns_event.id }
        expect(response).to require_login
      end
    end
  end

  describe "#update" do
    context "when user logged in" do
      describe "and event's creator" do
        before(:each) { sign_in @john }

        context "with valid information" do
          it "updates events information" do
            address = attributes_for(:address, city: "changed_city")
            put :update, params: { id: @johns_event.id,
                                   event: { name: "change_example",
                                            address_attributes: address } }
            @johns_event.reload
            expect(@johns_event.name).to eq("change_example")
            expect(@johns_event.address[:city]).to eq("changed_city")
          end

          it "redirects to updated event page" do
            address = attributes_for(:address, city: "changed_back")
            put :update, params: { id: @johns_event.id,
                                   event: { name: "change_back",
                                            address_attributes: address } }
            expect(response).to redirect_to event_path(@johns_event)
          end
        end

        context "with invalid information" do
          it "doesn't update event's information" do
            address = attributes_for(:address, city: "changed_city")
            put :update, params: { id: @johns_event.id,
                                   event: { name: nil,
                                            address_attributes: address } }
            @johns_event.reload
            expect(@johns_event.name).not_to eq("change_example")
            expect(@johns_event.address[:city]).not_to eq("changed_city")
          end

          it "renders edit template" do
            address = attributes_for(:address, city: "changed_city")
            put :update, params: { id: @johns_event.id,
                                   event: { name: nil,
                                            address_attributes: address } }
            expect(response).to render_template :edit
          end
        end
      end

      describe "and admin" do
        before(:each) { sign_in @admin }

        it "updates events information" do
          address = attributes_for(:address, city: "changed_city")
          put :update, params: { id: @johns_event.id,
                                 event: { name: "change_example",
                                          address_attributes: address } }
          @johns_event.reload
          expect(@johns_event.name).to eq("change_example")
          expect(@johns_event.address[:city]).to eq("changed_city")
        end

        it "updates events information" do
          address = attributes_for(:address, city: "changed_back")
          put :update, params: { id: @johns_event.id,
                                 event: { name: "change_back",
                                          address_attributes: address } }
          expect(response).to redirect_to event_path(@johns_event)
        end
      end

      describe "and not admin nor event's creator" do
        before(:each) { sign_in @paul }

        it "doesn't update event's information" do
          address = attributes_for(:address, city: "city")
          put :update, params: { id: @johns_event.id,
                                 event: { name: "name",
                                          address_attributes: address } }
          @johns_event.reload
          expect(@johns_event.name).not_to eq("name")
          expect(@johns_event.address[:city]).not_to eq("city")
        end

        it "redirects to events_path" do
          address = attributes_for(:address, city: "city")
          put :update, params: { id: @johns_event.id,
                                 event: { name: "name",
                                          address_attributes: address } }
          expect(response).to redirect_to events_path
        end
      end
    end

    context "when user not logged in" do
      it "doesn't update event's information" do
        address = attributes_for(:address, city: "city")
        put :update, params: { id: @johns_event.id,
                               event: { name: "name",
                                        address_attributes: address } }
        @johns_event.reload
        expect(@johns_event.name).not_to eq("name")
        expect(@johns_event.address[:city]).not_to eq("city")
      end

      it "redirects to login page" do
        address = attributes_for(:address, city: "city")
        put :update, params: { id: @johns_event.id,
                               event: { name: "name",
                                        address_attributes: address } }
        expect(response).to require_login
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "doesn't change event count" do
        expect do
          delete :destroy, params: { id: @johns_event.id }
        end.not_to change(Event, :count)
      end

      it "redirects to login page" do
        delete :destroy, params: { id: @johns_event.id }
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      describe "and not admin nor event's creator" do
        before(:each) { sign_in @paul }

        it "doesn't change event count" do
          expect do
            delete :destroy, params: { id: @johns_event.id }
          end.not_to change(Event, :count)
        end

        it "redirects to events_path" do
          delete :destroy, params: { id: @johns_event.id }
          expect(response).to redirect_to events_path
        end
      end

      describe "and admin" do
        before(:each) { sign_in @admin }

        it "deletes an event" do
          event = Event.last
          expect do
            delete :destroy, params: { id: event.id }
          end.to change(Event, :count).by(-1)
        end

        it "redirects to events_path" do
          event = Event.last
          delete :destroy, params: { id: event.id }
          expect(response).to redirect_to events_path
        end
      end

      describe "and event's creator" do
        it "deletes an event" do
          sign_in @paul
          expect do
            delete :destroy, params: { id: @pauls_event.id }
          end.to change(Event, :count).by(-1)
        end

        it "redirects to events_path" do
          sign_in @john
          event = Event.last
          delete :destroy, params: { id: event.id }
          expect(response).to redirect_to events_path
        end
      end
    end
  end
end

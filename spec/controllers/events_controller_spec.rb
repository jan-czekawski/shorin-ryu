require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe "#index" do
    it "renders index template and assigns array of all events to @events" do
      kumite = create(:event, name: "kumite")
      kata = create(:event, name: "kata")
      get :index
      expect(response).to render_template :index
      expect(assigns(:events)).to include(kata, kumite)
    end
  end

  describe "#show" do
    it "renders show template and assigns selected event to @event" do
      event = create(:event)
      get :show, params: { id: event.id }
      expect(response).to render_template :show
      expect(assigns(:event)).to eq event
    end
  end

  describe "#new" do
    context "when user logged in" do
      it "renders new template and assigns new instance of Event to @event" do
        sign_in create(:user)
        get :new
        expect(response).to render_template :new
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
      describe "with valid information" do
        it "creates new event and redirects to events path" do
          sign_in create(:user)
          address = attributes_for(:address)
          expect do
            post :create, params: { event: { name: "Home",
                                             address_attributes: address } }
          end.to change(Event, :count).by(1)
        end
      end

      describe "with invalid information" do
        it "doesn't create new event and renders template 'new'" do
          sign_in create(:user)
          address = attributes_for(:address)
          expect do
            post :create, params: { event: { name: nil,
                                             address_attributes: address } }
          end.not_to change(Event, :count)
          expect(response).to render_template :new
        end
      end
    end

    context "when user not logged in" do
      it "doesn't create a new event and redirects to login page" do
        address = attributes_for(:address)
        expect do
          post :create, params: { event: { name: "random name",
                                           address_attributes: address } }
        end.not_to change(Event, :count)
        expect(response).to require_login
      end
    end
  end

  describe "#edit" do
    context "when user logged in" do
      describe "and admin" do
        it "renders edit template and assigns selected event to @event" do
          sign_in create(:admin)
          event = create(:event)
          get :edit, params: { id: event.id }
          expect(response).to render_template :edit
          expect(assigns(:event)).to eq event
        end
      end

      describe "and event's creator" do
        it "renders edit template and assigns selected event to @event" do
          event = create(:event)
          sign_in event.user
          get :edit, params: { id: event.id }
          expect(response).to render_template :edit
          expect(assigns(:event)).to eq event
        end
      end

      describe "and not admin nor event's creator" do
        it "redirects to events_path" do
          event = create(:event)
          sign_in create(:user)
          get :edit, params: { id: event.id }
          expect(response).to redirect_to events_path
        end
      end
    end

    context "when user not logged in" do
      it "redirects to login page" do
        event = create(:event)
        get :edit, params: { id: event.id }
        expect(response).to require_login
      end
    end
  end

  describe "#update" do
    context "when user logged in" do
      context "and event's creator" do
        describe "with valid information" do
          it "updates events information and redirects to updated event page" do
            event = create(:event)
            sign_in event.user
            address = attributes_for(:address, city: "changed_city")
            put :update, params: { id: event.id,
                                   event: { name: "change_example",
                                            address_attributes: address } }
            event.reload
            expect(event.name).to eq("change_example")
            expect(event.address[:city]).to eq("changed_city")
            expect(response).to redirect_to event_path(event)
          end
        end

        describe "with invalid information" do
          it "doesn't update event's information and renders edit template" do
            event = create(:event)
            sign_in event.user
            address = attributes_for(:address, city: "changed_city")
            put :update, params: { id: event.id,
                                   event: { name: nil,
                                            address_attributes: address } }
            event.reload
            expect(event.name).not_to eq("change_example")
            expect(event.address[:city]).not_to eq("changed_city")
            expect(response).to render_template :edit
          end
        end
      end

      context "and admin" do
        it "updates events information and redirects to updated event" do
          event = create(:event)
          sign_in create(:admin)
          address = attributes_for(:address, city: "changed_city")
          put :update, params: { id: event.id,
                                 event: { name: "change_example",
                                          address_attributes: address } }
          event.reload
          expect(event.name).to eq("change_example")
          expect(event.address[:city]).to eq("changed_city")
          expect(response).to redirect_to event_path(event)
        end
      end

      context "and not admin nor event's creator" do
        it "doesn't update event's information and redirects to events_path" do
          sign_in create(:user)
          event = create(:event)
          address = attributes_for(:address, city: "city")
          put :update, params: { id: event.id,
                                 event: { name: "name",
                                          address_attributes: address } }
          event.reload
          expect(event.name).not_to eq("name")
          expect(event.address[:city]).not_to eq("city")
          expect(response).to redirect_to events_path
        end
      end
    end

    context "when user not logged in" do
      it "doesn't update event's information and redirects to login page" do
        event = create(:event)
        address = attributes_for(:address, city: "city")
        put :update, params: { id: event.id,
                               event: { name: "name",
                                        address_attributes: address } }
        event.reload
        expect(event.name).not_to eq("name")
        expect(event.address[:city]).not_to eq("city")
        expect(response).to require_login
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "doesn't change event count and redirects to login page" do
        event = create(:event)
        expect do
          delete :destroy, params: { id: event.id }
        end.not_to change(Event, :count)
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      context "and not admin nor event's creator" do
        it "doesn't change event count and redirects to events_path" do
          sign_in create(:user)
          event = create(:event)
          expect do
            delete :destroy, params: { id: event.id }
          end.not_to change(Event, :count)
          expect(response).to redirect_to events_path
        end
      end

      context "and admin" do
        it "deletes an event and redirects to events_path" do
          sign_in create(:admin)
          event = create(:event)
          expect do
            delete :destroy, params: { id: event.id }
          end.to change(Event, :count).by(-1)
          expect(response).to redirect_to events_path
        end
      end

      context "and event's creator" do
        it "deletes an event" do
          event = create(:event)
          sign_in event.user
          expect do
            delete :destroy, params: { id: event.id }
          end.to change(Event, :count).by(-1)
          expect(response).to redirect_to events_path
        end
      end
    end
  end
end

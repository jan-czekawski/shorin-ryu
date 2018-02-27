require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  
  before(:all) do
    @user = create(:user)
    @item = create(:item)
    @event = create(:event)
  end
  
  after(:all) do
    User.delete_all
    Item.delete_all
    Event.delete_all
  end

  describe "#post", :new do
    
    context "when user logged in" do
      
      describe "with valid event information" do
        it "increases comment count by 1" do
          sign_in @user
          expect do
            post :create, params: { event_id: @event.id,
                                    comment: { content: "random" } }
          end.to change(Comment, :count).by(1)
        end
        
        it "redirects to event page after creation" do
          sign_in @user
          post :create, params: { event_id: @event.id,
                                  comment: { content: "random" } }
          expect(response).to redirect_to event_path(@event)
        end
      end
      
    end
    
    context "when user not logged in" do
      it "doesn't change comment count" do
        expect do
          post :create, params: { event_id: @event.id,
                                  comment: { content: "random" } }
        end.not_to change(Comment, :count)
      end
      
      it "redirects to login url" do
        post :create, params: { event_id: @event.id,
                                comment: { content: "random" } }
        expect(response).to require_login
      end
    end
    
  end
  
end
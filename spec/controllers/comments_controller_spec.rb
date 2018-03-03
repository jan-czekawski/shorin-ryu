require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before(:all) do
    @user = create(:user)
    @item = create(:item)
    @event = create(:event)
  end

  describe "#post" do
    context "when user logged in" do
      before(:each) { sign_in @user }

      describe "with valid event information" do
        it "increases comment count by 1" do
          expect do
            post :create, params: { event_id: @event.id,
                                    comment: { content: "random" } }
          end.to change(Comment, :count).by(1)
        end

        it "redirects to event page after comment creation" do
          post :create, params: { event_id: @event.id,
                                  comment: { content: "random" } }
          expect(response).to redirect_to event_path(@event)
        end
      end

      describe "with valid item information" do
        it "increases comment count by 1" do
          expect do
            post :create, params: { item_id: @item.id,
                                    comment: { content: "random" } }
          end.to change(Comment, :count).by(1)
        end

        it "redirects to item page after comment creation" do
          post :create, params: { item_id: @item.id,
                                  comment: { content: "random" } }
          expect(response).to redirect_to item_path(@item)
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

  describe "#destroy" do
    context "when user not logged in" do
      it "doesn't change comment count" do
        comment = Comment.last
        expect do
          delete :destroy, params: { id: comment.id,
                                     event_id: @event.id }
        end.not_to change(Comment, :count)
      end

      it "redirects to login page" do
        comment = Comment.last
        delete :destroy, params: { id: comment.id,
                                   event_id: @event.id }
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      before(:each) { sign_in @user }

      describe "with valid event information" do
        it "decreases comment count by 1" do
          # TODO: check comment_id vs event_id and .. vs item_id
          comment = Comment.last
          expect do
            delete :destroy, params: { id: comment.id,
                                       event_id: @event.id }
          end.to change(Comment, :count).by(-1)
        end

        it "redirects to event page after comment is deleted" do
          comment = Comment.last
          delete :destroy, params: { id: comment.id,
                                     event_id: @event.id }
          expect(response).to redirect_to event_path(@event)
        end
      end

      describe "with valid item information" do
        it "decreases comment count by 1" do
          comment = Comment.last
          expect do
            delete :destroy, params: { id: comment.id,
                                       item_id: @item.id }
          end.to change(Comment, :count).by(-1)
        end

        it "redirects to item page after comment is deleted" do
          comment = Comment.last
          delete :destroy, params: { id: comment.id,
                                     item_id: @item.id }
          expect(response).to redirect_to item_path(@item)
        end
      end
    end
  end
end

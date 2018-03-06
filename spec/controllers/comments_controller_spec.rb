require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "#create" do
    context "when user logged in" do
      describe "with valid event information" do
        it "increases comment count by 1 and redirects to event" do
          sign_in create(:user)
          event = create(:event)
          expect do
            post :create, params: { event_id: event.id,
                                    comment: { content: "random" } }
          end.to change(Comment, :count).by(1)
          expect(response).to redirect_to event
        end
      end

      describe "with valid item information" do
        it "increases comment count by 1" do
          sign_in create(:user)
          item = create(:item)
          expect do
            post :create, params: { item_id: item.id,
                                    comment: { content: "random" } }
          end.to change(Comment, :count).by(1)
          expect(response).to redirect_to item
        end
      end
    end

    context "when user not logged in" do
      it "doesn't change comment count and redirects to login page" do
        event = create(:event)
        expect do
          post :create, params: { event_id: event.id,
                                  comment: { content: "random" } }
        end.not_to change(Comment, :count)
        expect(response).to require_login
      end
    end
  end

  describe "#destroy" do
    context "when user not logged in" do
      it "doesn't change comment count" do
        comment = create(:events_comment)
        expect do
          delete :destroy, params: { id: comment.id,
                                     event_id: comment.commentable_id }
        end.not_to change(Comment, :count)
        expect(response).to require_login
      end
    end

    context "when user logged in" do
      describe "with valid event information" do
        it "decreases comment count by 1 and redirects to event page" do
          # TODO: check comment_id vs event_id and .. vs item_id
          comment = create(:events_comment)
          sign_in comment.user
          expect do
            delete :destroy, params: { id: comment.id,
                                       event_id: comment.commentable_id }
          end.to change(Comment, :count).by(-1)
          expect(response).to redirect_to event_path(comment.commentable_id)
        end
      end

      describe "with valid item information" do
        it "decreases comment count by 1" do
          comment = create(:items_comment)
          sign_in comment.user
          expect do
            delete :destroy, params: { id: comment.id,
                                       item_id: comment.commentable_id }
          end.to change(Comment, :count).by(-1)
          expect(response).to redirect_to item_path(comment.commentable_id)
        end
      end
    end
  end
end

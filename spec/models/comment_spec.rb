require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe Comment, ".new" do
    it "creates valid items comment if all info is provided" do
      comment = build(:items_comment)
      expect(comment).to be_valid
    end
    
    it "creates valid events comment if all info is provided" do
      comment = build(:events_comment)
      expect(comment).to be_valid
    end
    
    it "requires that user id is present" do
      comment = build(:items_comment)
      comment.user_id = nil
      expect(comment).not_to be_valid
    end
    
    it "requires that commentable_id is present" do
      comment = build(:events_comment)
      comment.commentable_id = nil
      expect(comment).not_to be_valid
    end
    
    it "requires that commentable_type is present" do
      comment = build(:items_comment)
      comment.commentable_type = nil
      expect(comment).not_to be_valid
    end
    
    it "requires that content is present" do
      comment = build(:events_comment)
      comment.content = nil
      expect(comment).not_to be_valid
    end
  end
end

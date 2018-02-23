require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe Comment, ".new" do
    it "creates valid comment if all info is provided" do
      comment = build(:comment)
    end
  end
end

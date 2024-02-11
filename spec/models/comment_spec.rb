require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      comment = build(:comment)
      expect(comment).to be_valid
      expect(comment.errors).to be_empty
    end

    it 'is invalid without content' do
      comment_without_content = build(:comment, content: nil)
      expect(comment_without_content).to be_invalid
      expect(comment_without_content.errors[:content]).not_to be_empty
    end

    it 'is invalid with content more than 100 characters' do
      comment_with_long_content = build(:comment, content: 'a' * 101)
      expect(comment_with_long_content).to be_invalid
      expect(comment_with_long_content.errors[:content]).not_to be_empty
    end
  end
end

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it 'is invalid without title' do
      without_title = build(:task, title: nil)
      expect(without_title).to be_invalid
      expect(without_title.errors[:title]).not_to be_empty
    end

    it 'is invalid with title more than 20 characters' do
      with_long_title = build(:task, title: 'a' * 31)
      expect(with_long_title).to be_invalid
      expect(with_long_title.errors[:title]).not_to be_empty
    end

    it 'is invalid without deadline' do
      without_deadline = build(:task, deadline: nil)
      expect(without_deadline).to be_invalid
      expect(without_deadline.errors[:deadline]).not_to be_empty
    end

    it 'is invalid without importance' do
      without_importance = build(:task, importance: nil)
      expect(without_importance).to be_invalid
      expect(without_importance.errors[:importance]).not_to be_empty
    end

    it 'is invalid without is_group_task' do
      without_is_group_task = build(:task, is_group_task: nil)
      expect(without_is_group_task).to be_invalid
      expect(without_is_group_task.errors[:is_group_task]).not_to be_empty
    end
  end

  describe 'delegate method' do
    let(:group) { create(:group) }
    let(:user) { create(:user, group:) }
    let(:task) { create(:task, user:, group:) }

    it 'user_name to user.name' do
      expect(task.user_name).to eq(user.name)
    end

    it 'image_url to user.image_url' do
      expect(task.user_image_url).to eq(user.image_url)
    end
  end

  describe 'completed_by_name method' do
    let(:group) { create(:group) }
    let(:user) { create(:user, group:) }
    let(:task) { create(:task, user:, group:) }

    context 'when completed_by is present' do
      before { task.completed_by = user }
      it 'returns name of the user who completed the task' do
        expect(task.completed_by_name).to eq(user.name)
      end
    end

    context 'when completed_by is nil' do
      it 'return nil' do
        expect(task.completed_by_name).to be_nil
      end
    end
  end
end

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it 'is invalid without line_id' do
      without_line_id = build(:user, line_id: nil)
      expect(without_line_id).to be_invalid
      expect(without_line_id.errors[:line_id]).not_to be_empty
    end

    it 'is invalid without name' do
      without_name = build(:user, name: nil)
      expect(without_name).to be_invalid
      expect(without_name.errors[:name]).not_to be_empty
    end
  end

  describe 'authenticate_with_line_id' do
    let(:user) { create(:user) }
    let(:line_id) { 'test_line_id' }
    let(:name) { 'test_user' }
    let(:image_url) { 'test_image_url' }

    context 'when user is not exist' do # 新規ユーザーの場合
      it 'initializes a new user' do
        new_user = User.authenticate_with_line_id(line_id, name, image_url)
        expect(new_user.new_record?).to be true
        expect(new_user.line_id).to eq(line_id)
        expect(new_user.name).to eq(name)
        expect(new_user.image_url).to eq(image_url)
      end
    end

    context 'when existing user' do # 登録済ユーザーの場合
      it 'returns found_user' do
        found_user = User.authenticate_with_line_id(user.line_id, user.name, user.image_url)
        expect(found_user).to eq(user)
      end

      it 'updates user if name and image_url changed' do # 登録済ユーザーのLINEプロフィールが変わっていた場合
        found_user = User.authenticate_with_line_id(user.line_id, name, image_url)
        expect(found_user.name).to eq(name)
        expect(found_user.image_url).to eq(image_url)
      end
    end
  end
end

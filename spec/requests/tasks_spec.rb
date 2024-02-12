require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:group) { create(:group) }
  let(:user) { create(:user, group:) }
  let(:token) { generate_token_for_user(user) }
  let(:task) { create(:task, group:, user:) }
  let(:comment) { create(:comment, user:, task:) }

  describe 'GET /tasks' do
    before do
      task # userが作成したタスク
      member = create(:user, group:) # userと同じグループに所属するメンバー
      create(:task, group:, user: member) # メンバーが作成したタスク
    end
    it 'タスク一覧を取得する' do
      get '/tasks', headers: { 'Authorization' => "Bearer #{token}" }
      json = response.parsed_body

      expect(json['user_tasks'].length).to eq(1)
      expect(json['group_tasks'].length).to eq(2)
      expect(response.status).to eq(200)
    end
  end

  describe 'POST /tasks' do
    context 'is_group_taskがfalseの場合' do
      it 'タスクを作成する' do
        valid_params = {
          task: {
            title: 'title',
            is_group_task: false,
            importance: 1,
            deadline: Time.zone.today + 5.days,
            group_id: group.id
          }
        }
        expect { post '/tasks', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
          .to change(Task, :count).by(+1)
        expect(response.status).to eq(200)
      end
    end

    context 'is_group_taskがtrueの場合' do
      it 'タスクを作成し、LINE通知の送信を実行する' do
        valid_params = {
          task: {
            title: 'title',
            is_group_task: true,
            importance: 1,
            deadline: Time.zone.today + 5.days,
            group_id: group.id
          }
        }
        expect(TaskNotificationService).to receive(:new).and_call_original
        expect { post '/tasks', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
          .to change(Task, :count).by(+1)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'PUT /tasks/:id' do
    it 'タスクの内容を更新する' do
      valid_params = {
        task: {
          title: 'update_title',
          is_group_task: true,
          importance: 1,
          deadline: Time.zone.today + 5.days,
          group_id: group.id
        }
      }
      put "/tasks/#{task.id}", headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params
      expect(task.reload.title).to eq(valid_params[:task][:title])
      expect(response.status).to eq(200)
    end
  end

  describe 'PATCH /tasks/:id/complete' do
    it 'タスクを完了済みにする' do
      patch "/tasks/#{task.id}/complete", headers: { 'Authorization' => "Bearer #{token}" }
      task.reload
      expect(task.is_completed).to eq(true)
      expect(task.completed_by_id).to eq(user.id)
      expect(response.status).to eq(200)
    end
  end

  describe 'DELETE /tasks/:id' do
    before do
      task
      comment
    end
    it 'タスクを削除し、タスクに紐づくコメントも削除する' do
      expect { delete "/tasks/#{task.id}", headers: { 'Authorization' => "Bearer #{token}" } }
        .to change(Task, :count).by(-1)
        .and change(Comment, :count).by(-1)
      expect(response.status).to eq(204)
    end
  end

  describe 'Comments' do
    before do
      task
    end

    describe 'POST /tasks/:id/comments' do
      it 'タスクに紐づくコメントを作成する' do
        valid_params = { comment: { content: 'comment' } }

        expect do
          post "/tasks/#{task.id}/comments", headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params
        end
          .to change(Comment, :count).by(+1)
        expect(task.reload.comments.length).to eq(1)
        expect(response.status).to eq(200)
      end
    end

    describe 'PUT /tasks/:id/comments/:id' do
      it 'コメント内容を更新する' do
        valid_params = { comment: { content: 'update_comment' } }
        put "/tasks/#{task.id}/comments/#{comment.id}", headers: { 'Authorization' => "Bearer #{token}" },
                                                        params: valid_params

        expect(comment.reload.content).to eq(valid_params[:comment][:content])
        expect(response.status).to eq(200)
      end
    end

    describe 'DELETE /tasks/:id/commemts/:id' do
      before do
        comment
      end
      it 'コメントを削除する' do
        expect { delete "/tasks/#{task.id}/comments/#{comment.id}", headers: { 'Authorization' => "Bearer #{token}" } }
          .to change(Comment, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end
  end
end

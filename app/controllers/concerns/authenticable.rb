module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    # ヘッダーからトークンを取得
    token = request.headers['Authorization'].to_s.split.last

    begin
      # トークンをデコードしてユーザーを検証
      payload = JWT.decode(token, ENV.fetch('SECRET_KEY_BASE', nil)).first
      @current_user = User.find_by(id: payload['user_id'])
    rescue JWT::DecodeError
      # 認証エラーの場合
      render json: { errors: 'Unauthorized' }, status: :unauthorized and return
    end
    # ユーザーが存在しない場合の処理
    render json: { errors: 'User not found' }, status: :not_found if @current_user.nil?
  end
end

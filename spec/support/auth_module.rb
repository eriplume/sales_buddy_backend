module AuthModule
  def generate_token_for_user(user)
    JWT.encode({ user_id: user.id }, ENV.fetch('SECRET_KEY_BASE', nil))
  end
end
class TaskNotificationService
  def initialize(task)
    @task = task
  end

  def call
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_CHANNEL_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN', nil)
    end

    users = User.where(group_id: @task.group_id, notifications: true)
    users.each do |user|
      message = {
        type: 'text',
        text: "チームタスクが登録されました$\n\n『#{@task.title}』\nhttps://sbuddy-apparel.com/team",
        emojis: [
          {
            index: 14,
            productId: '5ac1bfd5040ab15980c9b435',
            emojiId: '082'
          }
        ]
      }
      response = client.push_message(user.line_id, message)
      Rails.logger.info response
    end
  end
end

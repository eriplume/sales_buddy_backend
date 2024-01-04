require 'line/bot'

class PushLineJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    users = User.where(notifications: true)
    users.each do |user|
      message = {
        type: 'text',
        text: '１週間の振り返りを入力しましょう！こちらから登録：https://sales-buddy-psi.vercel.app/weekly'
      }
      line_client.push_message(user.line_id, message)
      logger.info 'PushLineSuccess'
    end
  end

  private

  def line_client
    Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_CHANNEL_SECRET', nil)
      config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN', nil)
    end
  end
end

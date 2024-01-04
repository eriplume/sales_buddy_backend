require 'line/bot'

class PushLineJob < ApplicationJob
  queue_as :default

  def perform(*args)
    users = User.where(notifications: true)
    users.each do |user| 
      message = {
        type: 'text',
        text: "１週間の振り返りを入力しましょう！こちらから登録：https://sales-buddy-psi.vercel.app/weekly"
      }
      response = line_client.push_message(user.line_id, message)
      logger.info "PushLineSuccess"
    end
  end

  private

  def line_client
    Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end

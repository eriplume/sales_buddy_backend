namespace :push_line do
  desc "LINE通知メッセージ送信"
  task push_line_message: :environment do
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end

    users = User.where(notifications: true)
    users.each do |user|
      message = {
        type: 'text',
        text: "1週間おつかれさまでした🌼\n\n今週はどうでしたか？\n1週間の振り返りを入力しましょう！\n\nこちらから入力↓\nhttps://sales-buddy-psi.vercel.app/weekly"
      }
      response = client.push_message(user.line_id, message)
      p response
    end
  end
end
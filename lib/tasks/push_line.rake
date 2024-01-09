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
        text: "1週間お疲れ様でした $$\n\n今週はどうでしたか？\n頑張ったことの振り返りをしましょう $\n\nこちらから入力↓\nhttps://sales-buddy-psi.vercel.app/weekly",
        emojis: [
          {
            index: 11,
            productId: "5ac1bfd5040ab15980c9b435",
            emojiId: "098"
          },
          {
            "index": 12,
            "productId": "5ac21184040ab15980c9b43a",
            "emojiId": "195"
          },
          {
            "index": 44,
            "productId": "5ac21e6c040ab15980c9b444",
            "emojiId": "220"
          },
        ]
      }
      response = client.push_message(user.line_id, message)
      p response
    end
  end
end
every :sunday, at: '8pm' do
  runner 'PushLineJob.perform_later'
end

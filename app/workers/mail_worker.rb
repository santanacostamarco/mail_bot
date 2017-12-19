#Sidekiq.configure_client do |config|
#  config.redis = {db: 1}
#end

#Sidekiq.configure_server do |config|
#  config.redis = {db: 1}
#end

class MailWorker
  include Sidekiq::Worker
  
  def perform(mail)
    @mail = mail
    loop do
      sleep 10
      puts @mail
    end
  end
end

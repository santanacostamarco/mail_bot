#Sidekiq.configure_client do |config|
#  config.redis = {db: 1}
#end

#Sidekiq.configure_server do |config|
#  config.redis = {db: 1}
#end


class MailWorker
  include Sidekiq::Worker
  
  def perform
    loop do
      EmailModel.check
    end
  end
end

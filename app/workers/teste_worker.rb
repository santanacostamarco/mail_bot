class TesteWorker
  include Sidekiq::Worker

  def perform()
    loop do
      sleep 10
      puts "teste worker"
    end
  end
end

class CheckMailsJob < ApplicationJob
  queue_as :default
  require 'mail'
  def perform()
    loop do
      return Mail.find(keys: ["NOT", "SEEN"]) # keys: ["NOT", "SEEN"] / ["SUBJECT", "*"]
    end
  end
end

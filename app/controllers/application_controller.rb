class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def email_checker
    require 'mail'
    Mail.defaults do
      retriever_method :imap,
        :address => "imap.gmail.com",
        :port => 993,
        :user_name => "botnovahub@gmail.com",
        :password => "B4l3$tr4",
        :enable_ssl => true,
        :read_only => false
    end

    emails = CheckMailsJob.perform_now

    render html: emails.length

    
  end
end

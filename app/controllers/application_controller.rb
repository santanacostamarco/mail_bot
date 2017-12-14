class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def hello
    render html:  "teste"
    mail = MailController.new
    if mail.config
      Thread.new do
        @mail_trd = Thread.current
        loop do
          puts mail.check
          puts @mail_trd
        end
      end
    end
  end
end

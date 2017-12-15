class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def hello
    render html:  "teste"
    mail = MailController.new
    if mail.auth("botnovahub@gmail.com", "B4l3$tr4")
      puts "eeee"
    end
  end
 
end
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  def hello
    render html:  "teste auth"
    #mail = MailController.new
    #if mail.auth("botnovahub@gmail.com", "B4l3$tr4")
    #  puts "eeee"
    #end
    #MailWorker.perform_async()
    @mail = EmailModel.new
    puts @mail
    auth = @mail.auth("botnovahub@gmail.com", "B4l3$tr4")
    if auth == true
      MailWorker.perform_async(@mail)
    else
      puts auth
    end
  end
 
end
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  @@teste = EmailModel.new

#realiza a autenticação, ao instanciar
  def auth
    render html: @@teste.auth
  end
  # verifica a quantidade de emails no link /check
  def check_for_mails
    render html:  @@teste.check
  end
 
end
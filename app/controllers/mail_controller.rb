class MailController < ApplicationController
    require 'mail'

    require "net/http"
    require 'net/imap'  
  
    http = Net::HTTP.new("localhost", "3000")
    http.use_ssl = false
  
    def show
    end
  
    def create
      @@imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
      return "create successfull"
    end
  
  # realiza a autenticação, ao instanciar
    def auth
      begin
        @@imap.authenticate('PLAIN', "botnovahub@gmail.com", "B4l3$tr4")
        return "auth ok"
      rescue => exeption
        return exeption
      end
    end
  
  # Seleciona a caixa de emails
    def select_mailbox
      @@imap.examine("INBOX")
      return "caixa de entrada selecionada"
    end
  
  # verifica a quantidade de emails no link /check
    def check_for_mails
      if @@imap.search(["NOT", "SEEN"]).length > 0
       return "voce tem novos emails sua caixa"
      else
        return "caixa de emails vazia"
      end
    end

end

class MailController < ApplicationController
    require 'mail'
    require "net/http"
    require 'net/imap'  
  
    http = Net::HTTP.new("localhost", "3000")
    http.use_ssl = false
  
    def show
    end
  
    def create
        begin
            @@imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
            return true
        rescue => e
            puts e
            return false
        end
    end
  
  # realiza a autenticação, ao instanciar
    def auth
      begin
        @@imap.authenticate('PLAIN', "botnovahub@gmail.com", "B4l3$tr4")
        return true
      rescue => e
        puts e
        return false
      end
    end
  
  # Seleciona a caixa de emails
    def select_mailbox
        begin
            @@imap.examine("INBOX")
            return true
        rescue => e
            puts e
            return false
        end
    end
  
  # verifica a quantidade de emails no link /check
    def check_for_mails
        if @@imap.search(["NOT", "SEEN"]).length > 0
            return true
        else
            return false
        end
    end

    def get_mails_id
        return @@imap.search(["NOT", "SEEN"])
    end

    def get_headers(mail_id)
        return @@imap.fetch(mail_id, "ENVELOPE")[0].attr["ENVELOPE"]
    end
    def get_mails(mail_id)
        return @@imap.fetch(mail_id,'RFC822')[0].attr['RFC822']
    end

end

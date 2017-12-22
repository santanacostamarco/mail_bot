class MailController < ApplicationController
    require 'mail'
    require "net/http"
    require 'net/imap'
  
    http = Net::HTTP.new("localhost", "3000")
    http.use_ssl = true
    http.ssl_version = :TLSv1
    http.ciphers = ['DES-CBC3-SHA']  
  
    def show
        t  = MailController.new 
        if t.init
            if t.auth
                if t.select_mailbox
                    if t.check_for_mails 
                        @mensagem = "existem emails na sua caixa"
                        
                    else
                        @mensagem = "caixa de entrada vazia"
                    end
                else
                    @mensagem = "caixa de email nao encontrada"
                end
            else
                @mensagem = " a autenticação falhou"
            end
        else
            @mensagem = "falha ao criar a instancia de mail de NET::IMAP"
        end
    end
  
    def init
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
            @@imap.select("INBOX")
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
    def delete_mail(mail_id)
        #@@imap.store(mail_id, "+FLAGS", [:Deleted])
    end

    def create
        @email = Email.new
        @email.mail_id = 123123
        @email.message = "sdhSUDHUASDNKASJ"
        puts @email.attributes
        @email.save
    
    end 


end

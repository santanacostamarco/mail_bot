class MailController < ApplicationController
    require 'mail'
    require "net/http"
    require 'net/imap'
    require 'net/smtp'

    @@email_bot = "botnovahub@gmail.com" # usar variavel de ambiente
    @@senha_bot = "B4l3$tr4" # usar variavel de ambiente
  
    #http = Net::HTTP.new("localhost", "3000")
    #http.use_ssl = true
    #http.ssl_version = :TLSv1
    #http.ciphers = ['DES-CBC3-SHA']  
  
    def show
        @emails = Email.all
    end

    def main
        t  = MailController.new 
        if t.init
            if t.auth
                if t.select_mailbox
                    qtd = t.check_for_mails
                    if qtd > 0
                        t.get_mails_id.each do |mail_id|
                            headers = t.get_headers(mail_id)
                            email = Mail.read_from_string t.get_mails(mail_id)
                            email_data = Array.new
                            email_data << mail_id
                            email_data << headers.subject
                            email_data << headers.date
                            email_data << headers.from[0].name
                            email_data << "#{headers.from[0].mailbox}@#{headers.from[0].host}"
                            email_data << "#{headers.reply_to[0].mailbox}@#{headers.reply_to[0].host}"
                            email_data << email.text_part.body.to_s
                            create(email_data)
                        end
                        if qtd == 1
                            flash[:notice] = "#{qtd} novo email foi salvo"
                            redirect_to :action => "show"
                        else
                            flash[:notice] = "#{qtd} novos emails foram salvos"
                            redirect_to :action => "show"
                        end
                    else
                        flash[:notice] = "Não há novos emails"
                        redirect_to :action => "show"
                    end
                else
                    flash[:notice] = "caixa de email nao encontrada"
                    redirect_to :action => "show"
                end
            else
                flash[:notice] = " a autenticação falhou"
                redirect_to :action => "show"
            end
        else
            flash[:notice] = "falha ao criar a instancia de mail de NET::IMAP"
            redirect_to :action => "show"
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
        @@imap.authenticate('PLAIN', @@email_bot, @@senha_bot)
        return true
      rescue => e
        puts e
        return false
      end
    end
  
  # Seleciona a caixa de emails
    def select_mailbox
        begin
            # @@imap.examine("INBOX") # Seleciona a caixa de emails mas nao marca como 'seen'
            @@imap.select("INBOX") # Seleciona a caixa de emails e marca como 'seen'
            return true
        rescue => e
            puts e
            return false
        end
    end
  
  # verifica a quantidade de emails no link /check
    def check_for_mails
        return @@imap.search(["NOT", "SEEN"]).length
        
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

    def create(data)
        @email = Email.new
        @email.mail_id = data[0]
        @email.subject = data[1]
        @email.date = data[2]
        @email.from_name = data[3]
        @email.from_email = data[4]
        @email.from_reply_to = data[5]
        @email.message = data[6]
        @email.save
        return true
    end 

    def destroy
        begin
            @email.destroy
            flash[:notice] = "Email removido com sucesso"
            redirect_to :action => "show"
        rescue => e
            puts e
        end
    end

    def reply #implementar resposta do bot 
        bot_answer = "bla bbla bla bbla bla bbla bla bbla"
        @email = Email.first
        mail_to = @email.from_reply_to
        conversation = get_conversation(@email)
        if conversation == ""
            mail_subject = "CONVERSA##{@email.mail_id} > #{@email.subject}"
        else
            mail_subject = @email.subject
        end 
        msg = "Subject: #{mail_subject}\n#{bot_answer}"
        smtp = Net::SMTP.new('smtp.gmail.com', 587)
        smtp.enable_starttls
        smtp.start("gmail.com", @@email_bot, @@senha_bot, :login) do
            smtp.send_message(msg, @@email_bot, mail_to)
        end
        destroy()
    end

    def get_conversation(email)
        subject_arr = email.subject.split
        conversation = ""
        subject_arr.each do |str|
            if str.include? "CONVERSA#"
                conversation = str
            end
        end
        return conversation
        #if subject.include? "CONVERSA#"
        #    return subject
        #else
        #    return "CONVERSA##{email.mail_id}"
        #end

    end




end

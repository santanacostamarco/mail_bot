class MailImapController < ApplicationController
    require 'net/imap'
    require 'mail'

    def recieve
        email_config = JSON.parse(File.read('config/email_config.json'))
        imap = Net::IMAP.new(
            email_config['imap_address'],
            email_config['imap_port'],
            usessl = true,
            certs = nil,
            verify = false
        )
        imap.authenticate('PLAIN', email_config['email_address'], email_config['email_password'])
        #imap.examine("INBOX") # Seleciona a caixa de emails mas nao marca como 'seen'
        imap.select("INBOX") # Seleciona a caixa de emails e marca como 'seen'
        if imap.search(["NOT", "SEEN"]).length > 0
            imap.search(["NOT", "SEEN"]).each do |mail_id|
                email = email_fields(Mail.read_from_string(imap.fetch(mail_id,'RFC822')[0].attr['RFC822']))
                create(email)
            end
        end

        redirect_to :controller => "mail", :action => "show"

    end

    def email_fields(email)
        from = email[:from].to_s
        message = remove_older_messages(email.text_part.body.to_s.strip)
        fields = {
            'subject' => email.subject,
            'date' => email.date,
            'from_name' => from[0..(from.index("<")-1)],
            'from_email' => from[(from.index("<")+1)..(from.length-2)],
            'message' => message.strip
        }
        return fields
    end

    def remove_older_messages(body)
        body = body.split("\n")
        message = Array.new
        have_reply = false
        body.each do |b|
            if !b.include? ">"
                message << b
            else
                have_reply = true   
            end
        end
        if have_reply
            return message[0...-2].join
        else
            return message.join
        end
    end

    def create(email_arr)
        email = Email.new
        email.subject = email_arr['subject']
        email.date = email_arr['date']
        email.from_name = email_arr['from_name']
        email.from_email = email_arr['from_email']
        email.message = email_arr['message']
        email.status = "unseen"
        email.save
    end
    

    
=begin
    @@email_config = JSON.parse(File.read('config/email_config.json'))

    def recieve
        t  = MailImapController.new 
        if t.init
            if t.auth
                if t.select_mailbox
                    qtd = t.check_for_mails
                    if qtd > 0
                        t.get_mails_id.each do |mail_id|
                            headers = t.get_headers(mail_id)
                            email = Mail.read_from_string t.get_mails(mail_id) imap.fetch(mail_id,'RFC822')[0].attr['RFC822']
                            email_data = Array.new
                            email_data << mail_id
                            email_data << headers.subject
                            email_data << headers.date
                            email_data << headers.from[0].name
                            email_data << "#{headers.from[0].mailbox}@#{headers.from[0].host}"
                            email_data << "#{headers.reply_to[0].mailbox}@#{headers.reply_to[0].host}"
                            email_data << clean_body(email.text_part.body.to_s.strip)
                            create(email_data)
                        end
                        if qtd == 1
                            flash[:notice] = "#{qtd} novo email foi salvo"
                            redirect_to :controller => "mail", :action => "show"
                        else
                            flash[:notice] = "#{qtd} novos emails foram salvos"
                            redirect_to :controller => "mail", :action => "show"
                        end
                    else
                        flash[:notice] = "Não há novos emails"
                        redirect_to :controller => "mail", :action => "show"
                    end
                else
                    flash[:notice] = "caixa de email nao encontrada"
                    redirect_to :controller => "mail", :action => "show"
                end
            else
                flash[:notice] = " a autenticação falhou"
                redirect_to :controller => "mail", :action => "show"
            end
        else
            flash[:notice] = "falha ao criar a instancia de mail de NET::IMAP"
            redirect_to :controller => "mail", :action => "show"
        end
    end

    def clean_body(body) # remover mensagens antigas de emails de respndidos
        body = body.split("\n")
        message = Array.new
        have_reply = false
        body.each do |b|
            if !b.include? ">"
                message << b
            else
                have_reply = true   
            end
        end
        if have_reply
            return message[0...-2].join
        else
            return message.join
        end
    end
  
    def init
        begin
            @@imap = Net::IMAP.new(@@email_config['imap_address'], @@email_config['imap_port'], usessl = true, certs = nil, verify = false)
            return true
        rescue => e
            puts e
            return false
        end
    end
  
  # realiza a autenticação, ao instanciar
    def auth
      begin
        @@imap.authenticate('PLAIN', @@email_config['email_address'], @@email_config['email_password'])
        return true
      rescue => e
        puts e
        return false
      end
    end
  
  # Seleciona a caixa de emails
    def select_mailbox
        begin
            #@@imap.examine("INBOX") # Seleciona a caixa de emails mas nao marca como 'seen'
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
    #rever o metodo create para ficar apenar em um controller
    def create(data)
        @email = Email.new
        #@email.mail_id = data[0]
        @email.subject = data[1]
        @email.date = data[2]
        @email.from_name = data[3]
        @email.from_email = data[4]
        #@email.from_reply_to = data[5]
        @email.message = data[6]
        @email.status = "unseen"
        @email.save
        return true
    end
=end
end

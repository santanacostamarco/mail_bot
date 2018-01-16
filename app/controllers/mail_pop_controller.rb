class MailPopController < ApplicationController
    require 'mail'

    def recieve
        email_config = JSON.parse(File.read('config/email_config.json'))
        Mail.defaults do
            retriever_method :pop3,    :address => email_config['pop_address'],
                                        :port => email_config['pop_port'],
                                        :user_name => email_config['email_address'],
                                        :password => email_config['email_password'],
                                        :enable_ssl => true
        end
        Mail.all.each do |email|
            email = email_fields(email)
            create(email)
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
            'message' => message
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

    def recieve
        pop = Net::POP.new(@@email_config['pop_address']) # usar dados do config
        pop.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
        pop.start(@@email_config['email_address'], @@email_config['email_password']) # usar dados do config
        if !pop.mails.empty?
            qtd = pop.mails.length
            pop.mails.each do |mail|
                mail_data = Array.new
                mail_arr = mail.pop.split("\r\n")
                for i in 65..mail_arr.length
                    mail_data << mail_arr[i]
                end
                email = mail_fieds(mail_data)
                create(email)
                mail.delete
            end
            flash[:notice] = "#{qtd} emails Baixados com sucesso"
            redirect_to :controller => "mail", :action => "show"
        else
            flash[:notice] = "Caixa de entrada vazia"
            redirect_to :controller => "mail", :action => "show"
        end
        pop.finish
        
    end

    def mail_fieds(mail_data)
        if mail_data.class == Array
            msg_begin = 0
            msg_end = 0
            mail_data.each_with_index do |item, index|
                if item.class == String
                    if item.include? "Content-Type: text/plain"
                        msg_begin = index
                    end
                    if item.include? "Content-Type: text/html"
                        msg_end = index  
                    end  
                end            
            end
            message = Array.new
            for i in (msg_begin+1)..(msg_end-2)
                message << mail_data[i]
            end
            from = mail_data[0]
            from = from.split(" <")
            fields = Array.new
            fields = {
                'from_name' => from[0][6..from[0].length], 
                'from_email' => from[1], 
                'date' => mail_data[1], 
                'subject' => mail_data[3][9..mail_data[3].length],
                'message' => message.join(" ").to_s
            }
            return fields
        end
    end

    def create(mail_arr)
        @email = Email.new
        #@email.mail_id = data[0]
        @email.subject = mail_arr['subject']
        @email.date = mail_arr['date']
        @email.from_name = mail_arr['from_name']
        @email.from_email = mail_arr['from_email']
        #@email.from_reply_to = data[5]
        @email.message = mail_arr['message']
        @email.status = "unseen"
        @email.save
    end 
=end
end

class MailPopController < ApplicationController
    require 'net/pop'

    @@email_config = JSON.parse(File.read('config/email_config.json'))

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
    
end

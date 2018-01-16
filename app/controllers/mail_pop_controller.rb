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
        emails = Mail.all
        quantity = emails.length
        notice = ""
        if quantity > 0
            emails.each do |email|
                email = email_fields(email)
                create(email)
            end
            if quantity == 1
                notice = "#{quantity} novo email"
            else
                notice = "#{quantity} novos emails"
            end
        else
            notice = "Não há novos emails"
        end
        flash[:notice] = notice
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
end

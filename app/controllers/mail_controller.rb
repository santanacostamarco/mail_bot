class MailController < ApplicationController
    require 'mail'
    def config
        Mail.defaults do
            retriever_method :imap,
            :address => "imap.gmail.com",
            :port => 993,
            :user_name => "botnovahub@gmail.com",
            :password => "B4l3$tr4",
            :enable_ssl => true,
            :read_only => false
        end
        return true
    end
    
    def check
        emails = Mail.find(keys: ["NOT", "SEEN"]) # keys: ["NOT", "SEEN"] / ["SUBJECT", "*"]
        qtd = emails.length
        if qtd > 0
            return "tem"
        else
            return "nao tem"
        end
    end



    def show
    end
end
class EmailModel < ApplicationRecord
    require 'net/imap'
    require "net/http"
    http = Net::HTTP.new("localhost", "3000")
    http.use_ssl = false
    
    def auth
        begin
            @imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
            @imap.authenticate('PLAIN', "botnovahub@gmail.com", "B4l3$tr4")
            select_mailbox("INBOX")
            return "auth ok"
        rescue => exeption
            return exeption
        end
    end

    def select_mailbox(mailbox)
        return @imap.examine(mailbox)
    end

    def check
        return @imap.search(["NOT", "SEEN"]).length
    end
    
end

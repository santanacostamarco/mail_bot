class EmailModel < ApplicationRecord
    require 'net/imap'
    require "net/http"
    http = Net::HTTP.new("localhost", "3000")
    http.use_ssl = false

    def auth(login, password)
        @imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
        begin
            @imap.authenticate('PLAIN', login, password)
            return true
        rescue => error
            return error
        end
    end
    def check
        @imap.examine("INBOX")
        puts @imap.search(["NOT", "SEEN"]).length
    end
    def teste
        puts "teste"
    end
end

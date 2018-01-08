class MailPopController < ApplicationController
    require 'net/pop'

    def teste
        if pop = Net::POP3.new('pop.gmail.com')
            pop.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
            pop.start("botnovahub@gmail.com", "B4l3$tr4n0v4")
            if pop.mails.empty?
                puts "Nenhum email encontrado"
            else
                pop.each_mail do |mail|
                    mail_data = Array.new
                    mail_arr = mail.pop.split("\r\n") # tratar todo o email aqui e salvar no banco
                    return mail_arr
                    #mail.delete
                end
            end
        else
            puts "not ok"
        end
        pop.finish
    end
    
end

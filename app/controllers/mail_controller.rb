class MailController < ApplicationController
    require 'mail'
    require 'net/smtp'
    @@email_config = JSON.parse(File.read('config/email_config.json'))
    
    
    def index
        if File.file?('config/email_config.json')
            redirect_to :action => "show"
        else
            mail_config()
        end
    end

    def mail_config
        conf = {
            "pop_address" => "pop.gmail.com",
            "pop_port" => 995,
            "imap_address" => "imap.gmail.com",
            "imap_port" => 993,
            "smtp_address" => "smtp.gmail.com",
            "smtp_port" => 587,
            "email_address" => "botnovahub@gmail.com",
            "email_password" => "B4l3$tr4n0v4"
        }
        File.open("config/email_config.json","w") do |f|
            f.write(conf.to_json)
        end
        redirect_to :action => "index"
    end

    def show
        @emails = Email.all
    end

    def destroy
        begin
            @email.destroy
        rescue => e
            puts e
        end
    end
    def change_status
        begin
            if @email.status == "unseen"
                @email.status = "seen"
            else
                @email.status = "unseen"
            end
            @email.save
        rescue => e
            puts e
        end
    end

    def talk(email, conversation)
        @conversa = Conversation.new.create
        @conversa.talk(conversation, "") # uma linha vazia para iniciar a conversa.
        answer = @conversa.talk(conversation, email.message.strip).to_s
        output = get_answer_output(answer)
        return output
    end
    
    def get_answer_output(answer)
        comeco = answer.index('[')
        fim = answer.index(']')
        return answer[(comeco+2)..(fim-2)]
    end

    def reply #implementar resposta do bot 
        
        if @email = Email.where(["status = ?", "unseen"]).first
            mail_to = @email.from_email
            conversation = set_conversation(@email)
            if conversation == ""
                mail_subject = "CONVERSA##{@email.id} > #{@email.subject}"
            else
                mail_subject = @email.subject
            end 
            conversation = get_conversation(mail_subject)
            bot_answer = talk(@email, conversation)
            msg = "Subject: #{mail_subject}\n#{bot_answer}"
            smtp = Net::SMTP.new(@@email_config['smtp_address'], @@email_config['smtp_port']) # usar dados do config
            smtp.enable_starttls
            smtp.start("gmail.com", @@email_config['email_address'], @@email_config['email_password'], :login) do # usar dados do config
                smtp.send_message(msg, @@email_config['email_address'], mail_to)
            end
            change_status()
            flash[:notice] = "O email foi respondido e removido da fila"
            redirect_to :action => "show"
        else
            flash[:notice] = "Não há emails não lidos"
            redirect_to :action => "show"
        end
        
    end

    def clear_queuee #limpar fila de emails
        fila = Email.all
        fila.each do |email|
            @email = email
            destroy()
        end
        redirect_to :action => 'show'
    end

    def set_conversation(email)
        subject_arr = email.subject.split
        conversation = ""
        subject_arr.each do |str|
            if str.include? "CONVERSA#"
                conversation = str
            end
        end
        return conversation
    end
    def get_conversation(subject)
        subject_arr = subject.split
        conversation = ""
        subject_arr.each do |str|
            if str.include? "CONVERSA#"
                conversation = str
            end
        end
        return conversation
    end
end

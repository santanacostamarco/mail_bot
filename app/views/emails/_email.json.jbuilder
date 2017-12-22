json.extract! email, :id, :mail_id, :subject, :date, :from_name, :from_email, :from_reply_to, :message, :created_at, :updated_at
json.url email_url(email, format: :json)

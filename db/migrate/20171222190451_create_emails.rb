class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.integer :mail_id
      t.string :subject
      t.date :date
      t.string :from_name
      t.string :from_email
      t.string :from_reply_to
      t.text :message

      t.timestamps
    end
  end
end

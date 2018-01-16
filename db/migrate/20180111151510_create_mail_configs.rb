class CreateMailConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :mail_configs do |t|
      t.string :pop_address
      t.integer :pop_port
      t.string :imap_address
      t.integer :imap_port
      t.string :smtp_address
      t.string :smtp_port
      t.string :email_address
      t.string :email_password
      
      t.timestamps
    end
  end
end

class AddStatusToEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :status, :string
  end
end

class CreateEmailModels < ActiveRecord::Migration[5.1]
  def change
    create_table :email_models do |t|

      t.timestamps
    end
  end
end

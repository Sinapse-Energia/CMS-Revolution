class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :token
      t.string :password
      t.string :password_digest
      t.string :password_reset_token

      t.timestamps
    end
  end
end

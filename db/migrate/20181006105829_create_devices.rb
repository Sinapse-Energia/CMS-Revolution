class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :name
      t.jsonb :api_json
      t.references :user
      t.references :template

      t.timestamps
    end
  end
end

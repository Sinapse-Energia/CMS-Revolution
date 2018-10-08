class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.string :name
      t.string :json_name
      t.jsonb :hardware_json

      t.timestamps
      t.timestamps
    end
  end
end

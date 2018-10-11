class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.text :name, null:false
      t.text :id_code, null:false
      t.text :id_communication, null:false
      t.text :location, null:false
      t.decimal :longitude, :precision => 8, :scale => 2, null:false
      t.decimal :latitude,:precision => 8, :scale => 2, null:false
      t.decimal :altitude,:precision => 8, :scale => 2 ,null:false
      t.timestamp :date_installation, null:false
      t.integer :circuit_number, null:false
      t.text :name_street
      t.text :number_street
      t.text :power_installed
      t.text :power_contracted
      t.text :id_supply_contract
      t.text :clock_brand
      t.text :clock_model
      t.timestamps null: false 
    end
  end
end
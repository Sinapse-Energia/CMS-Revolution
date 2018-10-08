class AddInterfacesPeripheralsToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :interfaces_peripherals, :text
  end
end

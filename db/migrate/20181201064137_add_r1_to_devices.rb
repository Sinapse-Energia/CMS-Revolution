class AddR1ToDevices < ActiveRecord::Migration[5.2]
  def change
    add_column :devices, :r1, :string
    add_column :devices, :r2, :string
    add_column :devices, :r3, :string
    add_column :devices, :r4, :string
    add_column :devices, :r5, :string
    add_column :devices, :r6, :string
    add_column :devices, :r7, :string
  end
end

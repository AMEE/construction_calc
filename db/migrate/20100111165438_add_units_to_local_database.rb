class AddUnitsToLocalDatabase < ActiveRecord::Migration
  def self.up
    add_column :commutes, :units, :string
    add_column :deliveries, :units, :string
    add_column :energy_consumptions, :units, :string
    add_column :materials, :units, :string
    add_column :wastes, :units, :string
  end

  def self.down
    remove_column :commutes, :units
    remove_column :deliveries, :units
    remove_column :energy_consumptions, :units
    remove_column :materials, :units
    remove_column :wastes, :units
  end
end

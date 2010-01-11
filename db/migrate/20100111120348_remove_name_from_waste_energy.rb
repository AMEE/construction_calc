class RemoveNameFromWasteEnergy < ActiveRecord::Migration
  def self.up
    remove_column :wastes, :name
    remove_column :energy_consumptions, :name
  end

  def self.down
    add_column :wastes, :name, :string
    add_column :energy_consumptions, :name, :string
  end
end
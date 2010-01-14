class AddDistanceAndRepeatitionsToLocalDatabase < ActiveRecord::Migration
  def self.up
    add_column :commutes, :amount, :float
    add_column :deliveries, :amount, :float
    add_column :energy_consumptions, :amount, :float
    add_column :materials, :amount, :float
    add_column :wastes, :amount, :float
    add_column :commutes, :repetitions, :integer
    add_column :deliveries, :repetitions, :integer
  end

  def self.down
    remove_column :commutes, :amount
    remove_column :deliveries, :amount
    remove_column :energy_consumptions, :amount
    remove_column :materials, :amount
    remove_column :wastes, :amount
    remove_column :commutes, :repetitions
    remove_column :deliveries, :repetitions
  end
end
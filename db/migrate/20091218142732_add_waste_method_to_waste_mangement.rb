class AddWasteMethodToWasteMangement < ActiveRecord::Migration
  def self.up
    add_column :wastes, :waste_method, :string
  end

  def self.down
    remove_column :wastes, :waste_method
  end
end

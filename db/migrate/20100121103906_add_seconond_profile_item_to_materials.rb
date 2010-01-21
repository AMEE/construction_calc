class AddSeconondProfileItemToMaterials < ActiveRecord::Migration
  def self.up
    add_column :materials, :amee_profile_item2_id, :string
  end

  def self.down
    remove_column :materials, :amee_profile_item2_id
  end
end

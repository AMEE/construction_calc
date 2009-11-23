class AddEnergyTracking < ActiveRecord::Migration
  def self.up
    create_table :energy_consumptions, :force => true do |t|
      t.column :project_id,               :integer
      t.column :name,                     :string
      t.column :amee_profile_item_id,     :string
      t.column :energy_consumption_type,  :string
      t.column :carbon_output_cache,      :float
      t.timestamps
    end
    add_index :energy_consumptions, :project_id
  end

  def self.down
    drop_table :energy_consumptions
  end
end
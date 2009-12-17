class AddWasteConsumptions < ActiveRecord::Migration
  def self.up
    create_table :wastes, :force => true do |t|
      t.column :project_id,           :integer
      t.column :name,                 :string
      t.column :amee_profile_item_id, :string
      t.column :waste_type,        :string
      t.column :carbon_output_cache,  :float
      t.timestamps
    end
    add_index :wastes, :project_id
    add_index :wastes, :created_at
  end

  def self.down
    drop_table :wastes
  end
end
class AddMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials, :force => true do |t|
      t.column :project_id,           :integer
      t.column :name,                 :string
      t.column :amee_profile_item_id, :string
      t.column :material_type,        :string
      t.column :carbon_output_cache,  :float
      t.timestamps
    end
    add_index :materials, :project_id
    add_index :materials, :created_at
  end

  def self.down
    drop_table :materials
  end
end

class AddCommutes < ActiveRecord::Migration
  def self.up
    create_table :commutes, :force => true do |t|
      t.column :project_id,           :integer
      t.column :name,                 :string
      t.column :amee_profile_item_id, :string
      t.column :commute_type,         :string
      t.column :carbon_output_cache,  :float
      t.timestamps
    end
    add_index :commutes, :project_id
    add_index :commutes, :created_at
  end

  def self.down
    drop_table :commutes
  end
end
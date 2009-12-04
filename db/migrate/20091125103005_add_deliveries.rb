class AddDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries, :force => true do |t|
      t.column :project_id,           :integer
      t.column :name,                 :string
      t.column :amee_profile_item_id, :string
      t.column :delivery_type,        :string
      t.column :carbon_output_cache,  :float
      t.timestamps
    end
    add_index :deliveries, :project_id
  end

  def self.down
    drop_table :deliveries
  end
end
class AddProjects < ActiveRecord::Migration
  def self.up
    create_table :projects, :force => true do |t|
      t.column :client_id,  :integer
      t.column :name,       :string
      t.column :number,     :string
      t.column :value,      :string
      t.column :floor_area, :integer
      t.column :amee_profile, :string
      t.timestamps
    end
    add_index :projects, :client_id
  end

  def self.down
    drop_table :projects
  end
end
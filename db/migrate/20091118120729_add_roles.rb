class AddRoles < ActiveRecord::Migration
  def self.up
    create_table :roles, :force => true do |t|
      t.column :user_id,              :integer
      t.column :role_type,            :string
      t.column :allowable_id,         :string
      t.column :allowable_type,       :string
      t.timestamps
    end
    add_index :roles, :user_id
    add_index :roles, [:allowable_id, :allowable_type]
  end

  def self.down
    drop_table :roles
  end
end
class AddClients < ActiveRecord::Migration
  def self.up
    create_table :clients, :force => true do |t|
      t.column :name,       :string
      t.timestamps
    end
  end

  def self.down
    drop_table :clients
  end
end
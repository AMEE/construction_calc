class AddProjectStartDate < ActiveRecord::Migration
  def self.up
    add_column :projects, :start_date, :date
  end

  def self.down
    remove_column :projects, :start_date
  end
end

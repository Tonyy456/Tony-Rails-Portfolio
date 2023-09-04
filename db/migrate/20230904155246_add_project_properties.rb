class AddProjectProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :started, :date
    add_column :projects, :completed, :date
    add_column :projects, :teamsize, :integer
    add_column :projects, :time_taken, :integer
    add_column :projects, :work_taken, :integer
  end
end

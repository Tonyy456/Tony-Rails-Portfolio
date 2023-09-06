class AddCompletedToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :is_completed, :boolean
  end
end

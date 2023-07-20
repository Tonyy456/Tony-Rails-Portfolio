class RenamePinsTableToProjects < ActiveRecord::Migration[7.0]
  def change
    rename_table :pins, :projects
  end
end

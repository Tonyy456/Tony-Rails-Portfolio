class AddIrrelevantToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :irrelevant, :boolean
  end
end

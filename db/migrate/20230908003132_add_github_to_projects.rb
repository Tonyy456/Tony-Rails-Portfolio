class AddGithubToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :github, :string
  end
end

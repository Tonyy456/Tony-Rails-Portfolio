class AddPropertiesToTagProjectConnectorTable < ActiveRecord::Migration[7.0]
  def change
    # gets rid of redundant !marker on this.
    add_column :project_tags, :hidden, :boolean
  end
end

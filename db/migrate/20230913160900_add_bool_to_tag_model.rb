class AddBoolToTagModel < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :hide_in_view, :boolean
  end
end

class AddPageToPin < ActiveRecord::Migration[7.0]
  def change
    add_column :pins, :use_link, :boolean, default: false, null: false
    add_column :pins, :page, :string, default: ""
  end
end

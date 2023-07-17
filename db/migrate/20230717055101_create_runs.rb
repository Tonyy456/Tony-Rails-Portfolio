class CreateRuns < ActiveRecord::Migration[7.0]
  def change
    create_table :run do |t|
      t.date :date
      t.time :time
      t.float :distance
      t.timestamps
    end
  end
end

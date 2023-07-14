class CreateHomeVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :home_videos do |t|

      t.timestamps
    end
  end
end

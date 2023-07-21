class AddStringToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :refresh_token_strava, :string
    add_column :users, :access_token_strava, :string
    add_column :users, :expires_at_strava, :datetime
  end
end

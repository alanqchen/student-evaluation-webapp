class CreateTeamsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :teams, :users
    add_index :teams_users, [:team_id, :user_id], unique: true, name: 'index_teams_users'
    add_foreign_key :teams_users, :teams
    add_foreign_key :teams_users, :users
  end
end

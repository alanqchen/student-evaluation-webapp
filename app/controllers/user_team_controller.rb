class UserTeamController < ApplicationController

    def create
        @user_team = User_team.new user_team_params
    end

    def show
    end

    def destroy
        @user_team.destroy
    end


end

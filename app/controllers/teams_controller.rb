class TeamsController < ApplicationController
  def new
  end

  def create
    @team = Team.new team_params
  end

  def edit
  end

  def show
  end

  def destroy
  end

  private

    def team_params
      params.require(:team).permit :name
    end

end

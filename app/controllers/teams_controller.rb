class TeamsController < ApplicationController
  def new
    @course = Course.find_by id: params[:id]
  end

  def create
    @course = Course.find_by id: params[:id]
    @team = Team.new name: params[:team][:name], course_id: @course.id
    if @team.valid?
      if @team.save
        flash[:success] = {title: 'Success!', message: " Created #{@team.name}"}
        render turbo_stream: [
          turbo_stream.replace("modal", template: "teams/new"),
          turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
          turbo_stream.update("dashboardTop", template: "courses/show")
        ]
      else
        flash[:danger] = {title: 'Error!', message: " Failed to save #{@team.name}"}
        render turbo_stream: [
          turbo_stream.replace("modal", template: "teams/new"),
          turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
          turbo_stream.update("dashboardTop", template: "courses/show")
        ]
      end
    else
      flash[:danger] = {title: 'Error!', message: " #{@team.errors.full_messages.to_sentence}"}
      render turbo_stream: [
        turbo_stream.replace("modal", template: "teams/new"),
        turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
        turbo_stream.update("dashboardTop", template: "courses/show")
      ]
    end
  end

  def edit
  end

  #test with a team in the db and enter teams/id#
  def show
      @team = Team.find params[:id]
  end

  def destroy
  end

  private

    def team_params
      params.require(:team).permit :name, :id
    end

end

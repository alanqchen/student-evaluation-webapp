class TeamsController < ApplicationController
  before_action :logged_in_user
  before_action :valid_team, only: [:show, :edit, :update, :destroy]
  before_action :user_in_course, only: [:show, :edit, :update, :destroy]
  before_action :instructor_only, only: [:edit, :update, :destroy]

  def new
    @course = Course.find_by id: params[:id]
  end

  def create
    @course = Course.find_by id: params[:id]
    @team = Team.new name: params[:team][:name], course_id: @course.id
    if @team.valid?
      if @team.save
        render turbo_stream: [
          turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: "Created #{@team.name}" }),
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
    @team = Team.find params[:tid]
  end

  def show
    @course = Course.find_by id: params[:id]
    @team = Team.find params[:tid]
    @team_evals = all_course_team_evals @team
  end

  def update
    @team = Team.find params[:tid]
  end

  def destroy
    @team = Team.find params[:tid]
    @team.destroy
  end

  private

    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end

    def valid_team
      @course = Course.find_by id: params[:id]
      @team = Team.find_by id: params[:tid]
      if !@course
        redirect_to courses_path
      elsif !@team || !@team.course == @course
        redirect_to course_path(@course.id)
      end
    end

    def user_in_course
      if !current_user.courses.include? @course
        redirect_to courses_path
      end
    end

    def instructor_only
      unless current_user.instructor
        redirect_to course_path(@course)
      end
    end
end

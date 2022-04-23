class ProjectsController < ApplicationController
  before_action :logged_in_user
  before_action :valid_project_and_user, only: [:show, :edit, :update, :destroy]

  def show
    @course = Course.find_by id: params[:id]
    @project = Project.find_by id: params[:pid]
  end

  def create
    @course = Course.find_by id: params[:id]
    @project = Project.new name: params[:project][:name], course_id: @course.id, closed: false
    if @project.valid?
      if @project.save
        @course.projects << @project
        create_course_evals @course
        render turbo_stream: [
          turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: "Created #{@project.name}" }),
          turbo_stream.update("dashboardTop", template: "courses/show")
        ]
      else
        flash[:danger] = {title: 'Error!', message: " Failed to save #{@project.name}"}
        render turbo_stream: [
          turbo_stream.replace("modal", template: "projects/new"),
          turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
          turbo_stream.update("dashboardTop", template: "courses/show")
        ]
      end
    else
      flash[:danger] = {title: 'Error!', message: " Failed to save project: #{@project.errors.full_messages.to_sentence}"}
      render turbo_stream: [
        turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: "Project #{@project.name} has been create" }),
        turbo_stream.update("dashboardTop", template: "courses/show")
      ]
    end
  end

  def new
    @course = Course.find_by id: params[:id]
  end

  def edit
    @course = Course.find_by id: params[:id]
    @project = Project.find params[:pid]
    render turbo_stream: [
      turbo_stream.replace("modal", template: "projects/edit"),
      turbo_stream.update("dashboardTop", template: "projects/show")
    ]
  end

  def update
    @course = Course.find_by id: params[:id]
    @project = Project.find params[:pid]
    if @project.update name: params[:project][:name], closed: params[:project][:active] != '1'
      flash[:success] = {title: 'Success!', message: " Updated #{@project.name}"}
      render turbo_stream: [
        turbo_stream.replace("modal", template: "projects/edit"),
        turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
        turbo_stream.update("dashboardTop", template: "projects/show")
      ]
    else
      flash[:danger] = {title: 'Error!', message: " Failed to update project: #{@project.errors.full_messages.to_sentence}"}
      render turbo_stream: [
        turbo_stream.replace("modal", template: "projects/edit"),
        turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
        turbo_stream.update("dashboardTop", template: "projects/show")
      ]
    end
  end

  def destroy
    @course = Course.find_by id: params[:id]
    @project = Project.find params[:pid]
    @project.destroy
    render turbo_stream: [
      turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "Project #{@project.name} has been deleted" }),
      turbo_stream.update("dashboardTop", template: "courses/show")
    ]
  end

  private

    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end

    def valid_project_and_user
      @course = Course.find_by id: params[:id]
      @project = Project.find_by id: params[:pid]
      if !@course || !current_user.courses.include?(@course)
        redirect_to courses_path
      elsif !@project || !@course.projects.include?(@project)
        redirect_to course_path(@course.id)
      end
    end
end

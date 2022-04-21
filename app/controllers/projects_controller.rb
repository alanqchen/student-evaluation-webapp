class ProjectsController < ApplicationController

  def show
    @course = Course.find_by id: params[:id]
    @project = Project.find params[:pid]
  end

  def create
    @course = Course.find_by id: params[:id]
    @project = Project.new name: params[:project][:name], course_id: @course.id, closed: false
    if @project.valid?
      if @project.save
        @course.projects << @project
        update_course_evals @course
        flash[:success] = {title: 'Success!', message: " Created #{@project.name}"}
        render turbo_stream: [
          turbo_stream.replace("modal", template: "projects/new"),
          turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
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
        turbo_stream.replace("modal", template: "projects/new"),
        turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
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
    if @project.update name: params[:project][:name], closed: !params[:project][:closed]
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

  #def index
   # @projects = Project.all
  #end
end

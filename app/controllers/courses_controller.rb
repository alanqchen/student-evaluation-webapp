class CoursesController < ApplicationController
  before_action :logged_in_user
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :user_in_course, only: [:show, :edit, :update]

  # GET /courses
  def index
    @courses = Course.all
  end

  # GET /courses/1
  def show
    @course = Course.find params[:id]
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  def create
    @course = Course.create course_params
    unless @course.nil?
      @course.users << current_user
      flash[:success] = {title: 'Success!', message: " Created course #{@course.name}"}
    else
      flash[:danger] = {title: 'Error!', message: " Failed to create course: #{@course.errors.full_messages.to_sentence}"}
    end
    render turbo_stream: [
      turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
      turbo_stream.update("dashboardTop", template: "courses/index")
    ]
  end

  def new_user
    @course = Course.find params[:id]
  end

  def create_and_add_user
    @course = Course.find params[:id]
    user = User.find_by email: params[:user][:email]
    # check if need to create new student account
    if user.nil?
      temp_password = User.new_token.slice(0,12) + 'Ab_1'
      user = User.new name: params[:user][:name], email: params[:user][:email], password: temp_password, password_confirmation: temp_password, admin: false, instructor: false, student: true, approver: false
      user.temp_password = temp_password
      if user.valid?
        if user.save
          if user.send_activation_email
            user.courses << @course
            render turbo_stream: [
              turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: "#{user.email} has been added" }),
              turbo_stream.update("dashboardTop", template: "courses/show")
            ]
            update_user_course_evals user, @course
          else
            # Need all these else's since renders don't return and we can't have multiple called in a single branch
            user.destroy
            render turbo_stream: turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "Failed to send email to #{user.email}" })
          end
        else
          render turbo_stream: turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "#{user.email} was not able to be saved" })
        end
      else
        render turbo_stream: turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "#{user.email} was not able to be saved" })
      end
    else
      unless @course.user_ids.include? user.id
        user.courses << @course
        render turbo_stream: [
          turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: " #{user.email} has been added" }),
          turbo_stream.update("dashboardTop", template: "courses/show")
        ]
      else
        render turbo_stream: [
          turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "warning", message: " #{user.email} is already in the course" }),
          turbo_stream.update("dashboardTop", template: "courses/show")
        ]
      end
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update course_params
      render turbo_stream: [
        turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: " Course was successfully updated" }),
        turbo_stream.update("dashboardTop", template: "courses/show")
      ]
    else
      render turbo_stream: [
        turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: " Failed to update course" }),
        turbo_stream.update("dashboardTop", template: "courses/show")
      ]
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
    render turbo_stream: [
      turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "Course #{@course.name} has been deleted" }),
      turbo_stream.update("dashboardTop", template: "courses/index")
    ]
  end

  def edit_course_user
    @course = Course.find_by id: params[:id]
    @user = User.find_by id: params[:uid]
  end

  def destroy_course_user
    @course = Course.find_by id: params[:id]
    @user = User.find_by id: params[:uid]
    @course.users.delete @user
    render turbo_stream: [
      turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "#{@user.email} has been removed" }),
      turbo_stream.update("dashboardTop", template: "courses/show")
    ]
  end

  def update_course_user
    @course = Course.find_by id: params[:id]
    @user = User.find_by id: params[:uid]
    @team = Team.find_by name: params[:user][:team]
    if @team.nil?
      teams_to_delete = @user.teams.where course_id: @course.id
      @user.teams.delete teams_to_delete
    elsif !@user.team_ids.include? @team.id
      # To make things simpler, only support one team
      all_course_evals_to_user(@user, @course).each do |eval|
        eval.destroy
      end
      teams_to_delete = @user.teams.where course_id: @course.id
      @user.teams.delete teams_to_delete
      @user.teams << [@team]
      update_user_course_evals @user, @course
    end
    render turbo_stream: [
      turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: "#{@user.email} team set" }),
      turbo_stream.update("dashboardTop", template: "courses/show")
    ]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find params[:id]
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit :name, :active
    end

    def user_in_course
      unless @course.user_ids.include? current_user.id
        redirect_to dashboards_path
      end
    end

    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end
end

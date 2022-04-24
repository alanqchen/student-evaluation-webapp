class EvaluationsController < ApplicationController
  before_action :logged_in_user
  before_action :valid_evaluation, only: [:show, :edit, :update, :destroy]
  before_action :user_can_view, only: [:show, :edit, :update, :destroy]
  before_action :from_user_only, only: [:edit, :update]
  before_action :no_edit_after_complete, only: [:edit, :update]

  def index
    @evals = all_evals_from_user current_user, completed: false
  end

  def show
    @evaluation = Evaluation.find_by id: params[:id]
  end

  def edit
    @evaluation = Evaluation.find_by id: params[:id]
  end

  def update
    @evals = all_evals_from_user current_user, completed: false
    @evaluation = Evaluation.find_by id: params[:id]
    submit = !params[:submit].nil?
    if @evaluation.update comment: params[:evaluation][:comment], score: params[:evaluation][:score], completed: submit
      render turbo_stream: [
        turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: " Evaluation was successfully #{submit ? "submitted!" : "saved"}" }),
        turbo_stream.update("dashboardTop", template: "evaluations/index")
      ]
    else
      flash[:danger] = {title: 'Error!', message: " Failed to save evaluation: #{@evaluation.errors.full_messages.to_sentence}"}
      render turbo_stream: [
        turbo_stream.update("modal", template: "evaluations/edit"),
        turbo_stream.update("flash_alert", partial: "partials/flash", locals: { flash: flash }),
        turbo_stream.update("dashboardTop", template: "evaluations/index")
      ]
    end
  end

  private

    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end

    def valid_evaluation
      @evaluation = Evaluation.find_by id: params[:id]
      unless @evaluation
        redirect_to dashboards_path
      end
    end

    # user should be in the course, and either be an instructor of the course
    # or the evaluation from/to user is in the user's team
    def user_can_view
      user = current_user
      user_course_teams = course_teams_with_user @evaluation.project.course, current_user
      unless user.courses.include? @evaluation.project.course
        redirect_to dashboards_path, status: :see_other
      end
      unless user.instructor || user_course_teams[0].id == course_teams_with_user(@evaluation.project.course, @evaluation.from_user)[0].id
        redirect_to dashboards_path, status: :see_other
      end
    end

    # only the user that the evaluation is from
    def from_user_only
      unless @evaluation.from_user == current_user
        redirect_to dashboards_path, status: :see_other
      end
    end

    # don't allow editing after eval has been submitted
    def no_edit_after_complete
      if @evaluation.completed
        redirect_to dashboards_path, status: :see_other
      end
    end
end

class EvaluationsController < ApplicationController
  before_action :get_user, only: [:show, :edit, :submit, :unsubmit]

  def new
    unless logged_in?
      redirect_to login_url
    end
    @evaluate = Evaluation.new
  end

  def edit
    unless logged_in?
      redirect_to login_url
    end
  end

  def submit
  end

  def unsubmit
  end

  def show
    @evals = Evaluation.where from_user: current_user&.id
  end
end

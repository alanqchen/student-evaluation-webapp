class EvaluationsController < ApplicationController
  def new
  end

  def edit
  end

  def submit
  end

  def unsubmit
  end

  def show
    @evals = Evaluation.where from_user: current_user&.id
  end
end

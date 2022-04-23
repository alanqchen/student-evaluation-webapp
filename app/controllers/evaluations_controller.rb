class EvaluationsController < ApplicationController
  before_action :logged_in_user
  before_action :valid_evaluation_and_user

  def new
    unless logged_in?
      redirect_to login_url
    end
    @evaluation = Evaluation.new
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
    @evaluation = Evaluation.find_by id: params[:id]
  end

  private

    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end

    def valid_evaluation_and_user
      #@evaluation = Evaluation.find_by id: 
      #unless 
    end
end

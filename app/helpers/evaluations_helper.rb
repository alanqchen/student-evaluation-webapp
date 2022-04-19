module EvaluationsHelper
  def user_evals
    print("IN SHOW")
    @evals = Evaluation.where(from_user: current_user&.id)
  end
end

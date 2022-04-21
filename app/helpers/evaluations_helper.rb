module EvaluationsHelper
  def user_evals
    print "IN SHOW"
    @evals = Evaluation.where from_user: current_user&.id
  end

  def all_evals_to_user user
    Evaluation.where to_user: User.find_by(id: user.id)
  end

  def all_evals_from_user user
    Evaluation.where from_user: User.find_by(id: user.id)
  end

  def all_evals_from_user_not_completed user
    Evaluation.where from_user: User.find_by(id: user.id), completed: false
  end

  def all_course_evals_to_user user, course
    Evaluation.where(to_user: User.find_by(id: user.id)).filter {|eval| eval.project.course_id == course.id }
  end

  def all_course_evals_from_user user, course
    Evaluation.where(from_user: User.find_by(id: user.id)).filter {|eval| eval.project.course_id == course.id }
  end

  def all_course_project_evals project
    Evaluation.where project_id: Project.find_by(id: project.id)
  end

  def all_course_project_evals_to_user user, project
    Evaluation.where project_id: Project.find_by(id: project.id), to_user: user.id
  end

  def all_course_project_evals_from_user user, project
    Evaluation.where project_id: Project.find_by(id: project.id), from_user: user.id
  end

  def create_course_project_evals_for_user user, course, project
    teams = all_course_teams_for_user user, course
    teams.each do |team|
      team.users.each do |member|
        unless member.id == user.id
          if Evaluation.find_by(from_user_id: user.id, to_user_id: member.id, project_id: project.id).nil?
            new_eval = Evaluation.new from_user_id: user.id, to_user_id: member.id, project_id: project.id, score: 0, comment: 'TBF', completed: false
            new_eval.save
          end
          if Evaluation.find_by(from_user_id: member.id, to_user_id: user.id, project_id: project.id).nil?
            new_eval = Evaluation.new from_user_id: member.id, to_user_id: user.id, project_id: project.id, score: 0, comment: 'TBF', completed: false
            new_eval.save
          end
        end
      end
    end
  end

  def average_course_score_for_user user, course
    evals = all_course_evals_to_user user, course
    if evals.length == 0
      res = nil
    else
      evals.sum(&:score) / evals.length
    end
  end

  def update_user_course_evals user, course
    course.projects.each do |project|
      create_course_project_evals_for_user user, course, project
    end
  end

  def update_course_evals course
    course.projects.each do |project|
      course.users.each do |user|
        create_course_project_evals_for_user user, course, project
      end
    end
  end

  def filter_key_for_evaluation eval
    "#{User.find_by id: eval.from_user_id} #{User.find_by id: eval.to_user_id}".downcase
  end
end

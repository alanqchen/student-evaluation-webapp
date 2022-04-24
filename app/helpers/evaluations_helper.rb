module EvaluationsHelper
  def user_evals
    @evals = Evaluation.where from_user: current_user&.id
  end

  def all_evals_to_user user, completed: nil
    unless completed.nil?
      Evaluation.where to_user: user, completed: completed
    else
      Evaluation.where to_user: user
    end
  end

  def all_evals_from_user user, completed: nil
    unless completed.nil?
      Evaluation.where from_user: user, completed: completed
    else
      Evaluation.where from_user: user
    end
  end

  def all_course_evals_to_user user, course, completed: nil
    unless completed.nil?
      Evaluation.joins(:project).where to_user: user, project: {course: course}, completed: completed
    else
      Evaluation.joins(:project).where to_user: user, project: {course: course}
    end
  end
  def all_course_evals_from_user user, course, completed: nil
    unless completed.nil?
      Evaluation.joins(:project).where from_user: user, project: {course: course}, completed: completed
    else
      Evaluation.joins(:project).where from_user: user, project: {course: course}
    end
  end

  def all_course_project_evals project, completed: nil
    unless completed.nil?
      Evaluation.where project: project, completed: completed
    else
      Evaluation.where project: project
    end
  end

  def all_course_project_evals_to_user user, project, completed: nil
    unless completed.nil?
      Evaluation.where project: project, to_user: user, completed: completed
    else
      Evaluation.where project: project, to_user: user
    end
  end

  def all_course_project_evals_from_user user, project, completed: nil
    unless completed.nil?
      Evaluation.where project: project, from_user: user, completed: completed
    else
      Evaluation.where project: project, from_user: user
    end
  end

  def all_course_team_evals team, completed: nil
    unless completed.nil?
      Evaluation.joins(:project).where from_user: team.users, project: {course: team.course}, completed: completed
    else
      Evaluation.joins(:project).where from_user: team.users, project: {course: team.course}
    end
  end

  def all_course_project_team_evals team, project, completed: nil
    unless completed.nil?
      Evaluation.where project: project, from_user: team.users, completed: completed
    else
      Evaluation.where project: project, from_user: team.users
    end
  end

  def create_course_project_evals_for_user user, course, project
    evals_to_insert = []
    teams = all_course_teams_for_user user, course
    teams.each do |team|
      team.users.each do |member|
        unless member.id == user.id
          # Append to array so we can bulk insert
          evals_to_insert << {from_user_id: user.id, to_user_id: member.id, project_id: project.id, score: 0, comment: '', completed: false}
          evals_to_insert << {from_user_id: member.id, to_user_id: user.id, project_id: project.id, score: 0, comment: '', completed: false}
        end
      end
    end
    unless evals_to_insert.empty?
      result = Evaluation.insert_all evals_to_insert
    end
  end

  def remove_project_evals_for_user user, project
    Evaluation.delete all_course_project_evals_from_user(user, project)
    Evaluation.delete all_course_project_evals_to_user(user, project)
  end

  def average_course_score_for_user user, course
    evals = all_course_evals_to_user user, course, completed: true
    if evals.length == 0
      res = nil
    else
      evals.sum(&:score).to_f / evals.length
    end
  end

  def average_project_score project
    evals = all_course_project_evals project, completed: true
    if evals.length == 0
      res = nil
    else
      evals.sum(&:score).to_f / evals.length
    end
  end

  def average_team_project_score team, project
    evals = all_course_project_team_evals team, project, completed: true
    if evals.length == 0
      res = nil
    else
      evals.sum(&:score).to_f / evals.length
    end
  end

  def average_team_score team
    evals = all_course_team_evals team, completed: true
    if evals.length == 0
      res = nil
    else
      evals.sum(&:score).to_f / evals.length
    end
  end

  def average_user_score_given user
    evals = all_evals_from_user user, completed: true
    if evals.length == 0
      res = nil
    else
      evals.sum(&:score).to_f / evals.length
    end
  end

  def average_user_score_received user
    evals = all_evals_to_user user, completed: true
    if evals.length == 0
      res = nil
    else
      evals.sum(&:score).to_f / evals.length
    end
  end

  def create_user_course_evals user, course
    course.projects.each do |project|
      create_course_project_evals_for_user user, course, project
    end
  end

  def remove_user_course_evals user, course
    Evaluation.delete all_course_evals_from_user(user, course)
    Evaluation.delete all_course_evals_to_user(user, course)
  end

  def create_course_evals course
    course.projects.each do |project|
      course.users.each do |user|
        create_course_project_evals_for_user user, course, project
      end
    end
  end

  def filter_key_for_evaluation eval
    "#{eval.from_user.name} #{eval.to_user.name} #{eval.project.name} #{eval.project.course.name} #{eval.completed ? "submitted" : "todo"}".downcase
  end

  def badge_for_evaluation eval
    if eval.completed
      '<span class="bg-green-100 text-green-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded">Completed</span>'.html_safe
    else
      '<span class="bg-red-100 text-red-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded">Incomplete</span>'.html_safe
    end
  end
end

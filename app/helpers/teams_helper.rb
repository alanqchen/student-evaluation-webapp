module TeamsHelper
  def all_teams_in_course course
    Team.where course: course
  end

  def all_teams_for_user user
    user.teams
  end

  def all_course_teams_for_user user, course
    user.teams.where course: course
  end

  def add_team_to_user user, team
    user.teams << team
  end

  def filter_key_for_team team
    "#{team.name} #{team.course.name}".downcase
  end

  def course_teams_select_options course
    all_teams_in_course(course).map(&:name)
  end

  def course_teams_with_user course, user
    Team.joins(:users).where course: course, users: user
  end
end

module CoursesHelper
  def current_course
    @course
  end

  def get_num_users course
    course.users.length
  end

  def teams_with_user user
    course.teams.select { |team| team.user_ids.include? user.id }
  end
end

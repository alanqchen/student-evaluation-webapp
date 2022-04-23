module CoursesHelper
  def current_course
    @course
  end

  def get_num_users course
    course.users.length
  end

  def badge_for_course course
    if course.active
      '<span class="bg-green-100 text-green-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded">Active</span>'.html_safe
    else
      '<span class="bg-gray-100 text-gray-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded">Inactive</span>'.html_safe
    end
  end
end

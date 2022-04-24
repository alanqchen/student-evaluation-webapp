module ProjectsHelper
  def filter_key_for_project project
    "#{project.name} #{project.closed.to_s}".downcase
  end

  def badge_for_project project
    unless project.closed
      '<span class="bg-green-100 text-green-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded">Active</span>'.html_safe
    else
      '<span class="bg-gray-100 text-gray-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded">Inactive</span>'.html_safe
    end
  end
end

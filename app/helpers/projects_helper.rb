module ProjectsHelper
  def filter_key_for_project project
    "#{project.name} #{project.closed.to_s}".downcase
  end
end

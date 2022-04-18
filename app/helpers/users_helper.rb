module UsersHelper
  def gravatar_for user, size: 80, class: ''
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar #{binding.local_variable_get(:class)}"
  end

  def badges_for user
    badges = ''
    if user.admin
      badges += '<span class="bg-red-100 text-red-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded dark:bg-red-200 dark:text-red-900">Admin</span>'
    end
    if user.instructor
      badges += '<span class="bg-yellow-100 text-yellow-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded dark:bg-yellow-200 dark:text-yellow-900">Instructor</span>'
    elsif !user.admin
      badges += '<span class="bg-green-100 text-green-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded dark:bg-green-200 dark:text-green-900">Student</span>'
    end
    if user.approver
      badges += '<span class="bg-blue-100 text-blue-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded dark:bg-blue-200 dark:text-blue-800">Approver</span>'
    end
    badges.html_safe
  end
end

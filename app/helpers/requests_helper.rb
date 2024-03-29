module RequestsHelper
  def all_requests
    Request.all
  end

  def number_of_requests
    Request.count
  end

  def filter_key_for_request request
    "#{request.name} #{request.email} #{request.institution}".downcase
  end
end

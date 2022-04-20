module SessionsHelper
  # Logs in to the given user
  def log_in user
    session[:user_id] = user.id
  end

  # Logs out the current user
  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  # Remembers a user in a persistent session
  def remember user
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session
  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  # Returns the current logged-in user, or nil if none
  def current_user
    # use assignment, not comparison operator
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by id: user_id
      if (user && user.authenticated?(:remember, cookies[:remember_token]))
       log_in user
       @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  # Redirects to stored location (or to the default)
  def redirect_back_or default, params
    redirect_to(session[:forwarding_url] || default, params)
    session.delete :forwarding_url
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end

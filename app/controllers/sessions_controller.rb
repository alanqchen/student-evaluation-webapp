class SessionsController < ApplicationController
  before_action :logged_in_user, only: [:new]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)&.authenticate params[:session][:password]
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or dashboards_path, params
      else
        flash.now[:danger] = {title: 'Error!', message: " Account not activated. Check your email for an activation link. #{user.activation_token}"}
        render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
      end
    else
      flash.now[:danger] = {title: 'Error!', message: ' Invalid email/password combination'}
      render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
    end
  end

  def destroy
    # only log out if logged in
    log_out if logged_in?
    redirect_to root_url
  end

  private

      def logged_in_user
        unless !logged_in?
          # Displaying flashes with redirect not yet feasible or non-hacky with turbo
          redirect_to root_path
        end
      end
end

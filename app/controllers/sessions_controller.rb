class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)&.authenticate params[:session][:password]
    if user
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
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
end

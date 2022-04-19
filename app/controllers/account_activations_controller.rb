class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      redirect_to user
    else
      flash.now[:danger] = {title: 'Error!', message: ' Invalid activation link'}
      render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
    end
  end
end

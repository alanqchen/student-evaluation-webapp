class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      redirect_to dashboards_path
    else
      respond_to do |format|
        format.html { redirect_to login_path }
        format.turbo_stream { flash.now[:danger] = {title: 'Error!', message: ' Invalid activation link'} }
      end
      #flash.now[:danger] = {title: 'Error!', message: ' Invalid activation link'}
      #redirect_to login_path
      #render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
    end
  end
end

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      redirect_to dashboards_path
    else
      flash.now[:danger] = {title: 'Error!', message: ' Invalid activation link'}
      redirect_to login_path
    end
  end
end

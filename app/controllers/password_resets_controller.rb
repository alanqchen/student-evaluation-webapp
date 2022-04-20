class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
    end
    flash[:info] = { title: '', message: ' Email sent with password reset instructions' }
    render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
  end

  def edit
    render 'edit'
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.valid?
      if @user.update user_params
        flash[:success] = { title: 'Success!', message: ' Password has been reset' }
      else
        flash.now[:danger] = {title: 'Error!', message: ' Failed to save new password'}
      end
    else
      flash.now[:danger] = {title: 'Error!', message: " #{@user.errors.full_messages.to_sentence}"}
    end
    render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by email: params[:email]
    end

    # Confirms a valid user
    def valid_user
      unless (@user && @user.activated? && 
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = { title: 'Error!', message: ' Password reset has expired' }
        render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
      end
    end
end

class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]

  def show
    @user = User.find params[:id]
  end

  def new
  end

  def create
    @user = User.new user_params
    if @user.save
      # TODO
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    changed_email = @user.email != params[:user][:email]
    changed_name = @user.name != params[:user][:name]
    changed_password = !params[:user][:password].empty? || !params[:user][:password_confirmation].empty?
    check_attributes = []
    update_attributes = {}
    if changed_email
      check_attributes << :email
      update_attributes[:email] = params[:user][:email]
    end
    if changed_name
      check_attributes << :name
      update_attributes[:name] = params[:user][:name]
    end
    if changed_password
      check_attributes << :password
      check_attributes << :password_confirmation
      update_attributes[:password] = params[:user][:password]
      update_attributes[:password_confirmation] = params[:user][:password_confirmation]
    end
    unless check_attributes.empty?
      validate_user = User.new email: params[:user][:email], name: params[:user][:name], password: params[:user][:password], password_confirmation: params[:user][:password_confirmation]
      if validate_user.valid_attributes? *check_attributes
        @user.attributes = update_attributes
        if @user.save(validate: false)
          flash.now[:success] = {title: 'Success!', message: " Saved changes"}
        else
          flash.now[:danger] = {title: 'Error!', message: ' Failed to save changes'}
        end
      else
        flash.now[:danger] = {title: 'Error!', message: " #{validate_user.errors.full_messages.to_sentence}"}
      end
    else
      flash.now[:info] = {title: 'Whoops!', message: ' No changes to save'}
    end
    render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })

    # # Check if only updating email
    # if params[:user][:password].empty? && params[:user][:password_confirmation].empty? && @user.email != params[:user][:email]
    #   if validate_user.valid_attributes? :email
    #     if @user.update_attribute(:email, params[:user][:email])
    #       flash.now[:success] = {title: 'Success!', message: ' Changes saved'}
    #     else
    #       flash.now[:danger] = {title: 'Error!', message: ' Failed to save changes'}
    #     end
    #   else
    #     flash.now[:danger] = {title: 'Error!', message: " #{validate_user.errors.full_messages.to_sentence}"}
    #   end
    # elsif @user.email == params[:user][:email]
    #   # not updating email
    #   if validate_user.valid_attributes? :password, :password_confirmation
    #     if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
    #       flash.now[:success] = {title: 'Success!', message: ' Changes saved'}
    #     else
    #       flash.now[:danger] = {title: 'Error!', message: ' Failed to save changes'}
    #     end
    #   else
    #     flash.now[:danger] = {title: 'Error!', message: " #{validate_user.errors.full_messages.to_sentence}"}
    #   end
    # else
    #   # Updating password and email
    #   if validate_user.valid?
    #     if @user.update(params[:user])
    #       flash.now[:success] = {title: 'Success!', message: ' Changes saved'}
    #     else
    #       flash.now[:danger] = {title: 'Error!', message: ' Failed to save changes'}
    #     end
    #   else
    #     flash.now[:danger] = {title: 'Error!', message: " #{validate_user.errors.full_messages.to_sentence}"}
    #   end
    # end
    # render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
  end

    private

      def user_params
        params.require(:user).permit :name, :email, :password, :password_confirmation
      end

      def logged_in_user
        unless logged_in?
          # Displaying flashes with redirect not yet feasible or non-hacky with turbo
          redirect_to login_url
        end
      end
end

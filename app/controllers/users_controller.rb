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
      @user.send_activation_email
      flash[:warning] = {title: 'Activation:', message: ' Please check your email to activate your account'}
      render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
    else
      render 'new'
    end
  end

  # Given params[:id]
  def show_edit_user
    render 'edit_user', locals: { edit_user: User.find_by(id: params[:id]) }
  end

  # Route to edit the user with the given id
  # Given params[:id]
  def edit_user
    edit_given_user User.find_by(id: params[:id]), params
    render 'edit_user', locals: { edit_user: User.find_by(id: params[:id]) }, status: :unprocessable_entity
  end

  # Route to edit the current user
  def edit
    edit_given_user current_user, params
    render turbo_stream: [
      turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash }),
      turbo_stream.update("navbarTop", partial: "partials/navbar"),
      turbo_stream.update("dashboardTop", template: "dashboards/edit_dashboard")
    ]
  end

  # Given params[:id]
  def destroy
    email = User.find_by(id: params[:id]).email
    User.find_by(id: params[:id]).destroy
    render turbo_stream: [
      turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "#{email} has been deleted" }),
      turbo_stream.update("dashboardTop", template: "dashboards/manage_users")
    ]
  end

    private

      def user_params
        params.require(:user).permit :name, :email, :password, :password_confirmation
      end

      def logged_in_user
        unless logged_in?
          store_location
          # Displaying flashes with redirect not yet feasible or non-hacky with turbo
          redirect_to login_url
        end
      end

      # Confirms the correct user
      def correct_user
        @user = User.find params[:id]
        redirect_to root_url unless current_user? @user
      end

      # Edits the given user with the given params
      def edit_given_user user, params
        # Get the roles as set by the given params (if none, will be nil)
        role_instructor = params[:user][:instructor] == '1'
        role_student = params[:user][:student] == '1'
        role_approver = params[:user][:approver] == '1'

        # Check what has been changed
        changed_email = user.email != params[:user][:email]
        changed_name = user.name != params[:user][:name]
        changed_password = !params[:user][:password].empty? || !params[:user][:password_confirmation].empty?
        changed_role_instructor = !params[:user][:instructor].nil? && user.instructor != role_instructor
        changed_role_student = !params[:user][:student].nil? && user.student != role_student
        changed_role_approver = !params[:user][:approver].nil? && user.approver != role_approver

        # For each changed attribute, add the symbol to a list of attributes to verify
        # and a hash to store the new values
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
        if changed_role_instructor
          check_attributes << :instructor
          update_attributes[:instructor] = role_instructor
        end
        if changed_role_student
          check_attributes << :student
          update_attributes[:student] = role_student
        end
        if changed_role_approver
          check_attributes << :approver
          update_attributes[:approver] = role_approver
        end

        unless check_attributes.empty?
          validate_user = User.new email: params[:user][:email], name: params[:user][:name], password: params[:user][:password], password_confirmation: params[:user][:password_confirmation], instructor: params[:user][:instructor], student: params[:user][:student], approver: params[:user][:approver]
          # Run extra password validation
          unless !changed_password
            validate_user.extra_password_validation
          end
          if validate_user.valid_attributes? *check_attributes
            user.attributes = update_attributes
            if user.save validate: false
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
      end
end

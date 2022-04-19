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

  # Given params[:id]
  def show_edit_user
    render 'edit_user', locals: { edit_user: User.find_by(id: params[:id]) }
  end

  # Given params[:id]
  def edit_user
    edit_given_user User.find_by(id: params[:id]), params
    render 'edit_user', locals: { edit_user: User.find_by(id: params[:id]) }, status: :unprocessable_entity
  end

  def edit
    edit_given_user current_user, params
    render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
  end

  # Given params[:id]
  def destroy
    email = User.find_by(id: params[:id]).email
    User.find_by(id: params[:id]).destroy
    render 'destroy_user', locals: { deleted_email: email }
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

      def edit_given_user user, params
        role_instructor = params[:user][:instructor] == '1'
        role_student = params[:user][:student] == '1'
        role_approver = params[:user][:approver] == '1'
        changed_email = user.email != params[:user][:email]
        changed_name = user.name != params[:user][:name]
        changed_password = !params[:user][:password].empty? || !params[:user][:password_confirmation].empty?
        changed_role_instructor = user.instructor != role_instructor
        changed_role_student = user.student != role_student
        changed_role_approver = user.approver != role_approver

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
          if validate_user.valid_attributes? *check_attributes
            user.attributes = update_attributes
            if user.save(validate: false)
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

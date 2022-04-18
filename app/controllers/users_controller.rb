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

    private

      def user_params
        params.require(:user).permit :name, :email, :password, :password_confirmation
      end

      def logged_in_user
        unless logged_in? || params[:id] != current_user&.id
          # Displaying flashes with redirect not yet feasible or non-hacky with turbo
          redirect_to login_url
        end
      end
end

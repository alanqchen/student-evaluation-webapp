class DashboardsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:manage_users]

  # GET /dashboards or /dashboards.json
  def index

  end

  def edit
  end

  def manage_users
    @users = User.all
  end

  private

      def logged_in_user
        unless logged_in?
          # Displaying flashes with redirect not yet feasible or non-hacky with turbo
          redirect_to login_url
        end
      end

      def admin_user
        unless current_user.admin
          redirect_to dashboards_path
        end
      end
end

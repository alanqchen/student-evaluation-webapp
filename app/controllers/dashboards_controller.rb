class DashboardsController < ApplicationController
  before_action :logged_in_user

  # GET /dashboards or /dashboards.json
  def index
    
  end

  def edit
  end

  private

      def logged_in_user
        unless logged_in?
          # Displaying flashes with redirect not yet feasible or non-hacky with turbo
          redirect_to login_url
        end
      end
end

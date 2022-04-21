class ApplicationController < ActionController::Base
  include SessionsHelper
  include UsersHelper
  include EvaluationsHelper
  include TeamsHelper
end

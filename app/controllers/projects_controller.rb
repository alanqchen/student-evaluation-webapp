class ProjectsController < ApplicationController
  
  def show
    @project = Project.find params[:id]
  end

  def new
  
  end
  
  #def index
   # @projects = Project.all
  #end
end

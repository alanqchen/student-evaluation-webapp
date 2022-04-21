class UserTeamController < ApplicationController
    
    def index
        @section = Section.find (params[:section_id])
        @groups = Group.where section_id: @section.id
    end


end

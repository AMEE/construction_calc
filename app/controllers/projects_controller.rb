class ProjectsController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project, :only => [:show]
  before_filter :ensure_project_readable_by_user, :only => [:show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  def index
    @projects = @client.projects.readable_by_user(current_user)
  end
  
  def show
  end
  
  private
  def find_project
    @project = @client.projects.find(params[:id])
  end
end
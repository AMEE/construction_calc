class ProjectsController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project, :only => [:show]
  before_filter :ensure_project_readable_by_user, :only => [:show]
  before_filter :admin_or_client_admin_required, :only => [:new, :create, :edit, :update]
  
  def index
    @projects = @client.projects.readable_by_user(current_user)
  end
  
  def new
    @project = Project.new(params[:project])
  end
  
  def create
    @project = Project.new(params[:project])
    @project.client = @client
    if @project.save
      flash[:notice] = "Project created"
      redirect_to projects_path
    else
      render :new
    end
  end
  
  def show
    # No extra work required here
  end
  
  def edit
    @project = @client.projects.find(params[:id])
  end
  
  def update
    @project = @client.projects.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:notice] = "Project updated"
      redirect_to project_path(@project)
    else
      render :edit
    end
  end
  
  private
  def find_project
    @project = @client.projects.find(params[:id])
  end
end
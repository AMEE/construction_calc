class ProjectsController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project, :only => [:show]
  before_filter :ensure_project_readable_by_user, :only => [:show]
  before_filter :admin_or_client_admin_required, :only => [:new, :create, :edit, :update, :destroy]
  
  # def index
  #   @projects = @client.projects.readable_by_user(current_user)
  # end
  
  def new
    @project = @client.projects.new(params[:project])
  end
  
  def create
    @project = @client.projects.new(params[:project])
    if @project.save
      @users = @client.associated_users_readable_by(current_user)
      render
    else
      render :new
    end
  end
  
  def show
    if !current_user.can_write?(@project)
      flash[:info] =
        "Please note that you have read-only access to the #{@project.name} project.
        You will not be able to update any of the values below."
    else
      flash[:info] = nil
    end
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
  
  def destroy
    @project = @client.projects.find(params[:id])
    @project.destroy
    flash[:notice] = "Project deleted"
    redirect_to root_path
  end
  
  private
  def find_project
    @project = @client.projects.find(params[:id])
  end
end
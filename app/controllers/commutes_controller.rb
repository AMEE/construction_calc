class CommutesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  def index
    @commutes = @project.commutes
  end

  def new
    @commute = @project.commutes.new(params[:commute])
  end
  
  def create
    @commute = @project.commutes.new(params[:commute])
    if @commute.save
      flash[:notice] = "Commute created"
      redirect_to project_path(@project)
    else
      flash[:error] = "Unable to create commute"
      render :action => "new"
    end
  end
  
  def edit
    @commute = @project.commutes.find(params[:id])
  end
  
  def update
    @commute = @project.commutes.find(params[:id])
    if @commute.update_attributes(params[:commute])
      flash[:notice] = "Commute updated"
      redirect_to project_path(@project)
    else
      flash[:error] = "Unable to update commute"
      render :action => "edit"
    end
  end
  
  def destroy
    @commute = @project.commutes.find(params[:id])
    @commute.destroy
    flash[:notice] = "Commute destroyed"
    redirect_to project_path(@project)
  end
end
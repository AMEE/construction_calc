class CommutesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  def index
    @commutes = @project.commutes.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.js
    end
  end

  def new
    @commute = @project.commutes.new(params[:commute])
    respond_to do |format|
      format.js
    end
  end
  
  def create
    @commute = @project.commutes.new(params[:commute])
    if @commute.save
      flash[:notice] = "Commute created"
    else
      flash[:error] = ["Unable to create commute"] + @commute.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def edit
    @commute = @project.commutes.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @commute = @project.commutes.find(params[:id])
    if @commute.update_attributes(params[:commute])
      flash[:notice] = "Commute updated"
    else
      flash[:error] = ["Unable to update commute"] + @commute.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def destroy
    @commute = @project.commutes.find(params[:id])
    @commute.destroy
    flash[:notice] = "Commute destroyed"
    redirect_to project_path(@project)
  end
end
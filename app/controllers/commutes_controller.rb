class CommutesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  # TODO create two in a minute - will it blow up??  Yes
  # TODO type means ordering always changes - solve by alphabetical order?  What about units - same problem?
  # TODO paging issue will almost certainly occur on ice category one (material)
  # TODO lookup of required data item ids at application startup (note if staging may need to restart in app doc)
  # TODO type mappings, not available = can't have, recycle/dispose types
  # TODO write tests for access rights and test myself
  
  # TODO meeting notes:
  #   - Assumptions on types
  #       What to use for freight train
  #       LGV, HGV, articulated classifications - differences and mappings
  #       waste mappings
  #       material assumptions + missing two
  #   - Also we need to decide units everything specified in
  #   - unit.rb and commute.rb encapsulation with James on Monday
  
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
class CommutesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  # TODO can't change unit once created when editing - or we'd have to perform client side [possible extension would be to request in new unit from AMEE]
  
  # TODO type mappings, not available = can't have, recycle/dispose types
  
  # TODO meeting notes:
  #   - Assumptions on types
  #       What to use for freight train
  #       LGV, HGV, articulated classifications - differences and mappings
  #       waste mappings
  #       material assumptions + missing two
  #   - Also we need to decide units everything specified in
  #   - unit.rb and commute.rb encapsulation with James on Monday
  # TODO prototype -> different fields for different types (is field name the same? just one field? have units as JS stored that change on dropdown change?)
  # TODO architecture if can only do 1 API call
  # TODO checkin
  
  # TODO lookup of required data item ids at application startup (note if staging may need to restart in app doc)
  # TODO write tests for access rights and test myself
  
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
  
  def show
    @commute = @project.commutes.find(params[:id])
  end
end
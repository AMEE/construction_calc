class DeliveriesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  def index
    @deliveries = @project.deliveries.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.js
    end
  end

  def new
    @delivery = @project.deliveries.new(params[:delivery])
    respond_to do |format|
      format.js
    end
  end
  
  def create
    @delivery = @project.deliveries.new(params[:delivery])
    if @delivery.save
      flash[:notice] = "Delivery created"
    else
      flash[:error] = ["Unable to create delivery"] + @delivery.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def edit
    @delivery = @project.deliveries.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @delivery = @project.deliveries.find(params[:id])
    if @delivery.update_attributes(params[:delivery])
      flash[:notice] = "Delivery updated"
    else
      flash[:error] = ["Unable to update delivery"] + @delivery.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def destroy
    @delivery = @project.deliveries.find(params[:id])
    @delivery.destroy
    flash[:notice] = "Delivery destroyed"
    redirect_to project_path(@project)
  end
end
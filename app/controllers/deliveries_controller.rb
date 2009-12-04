class DeliveriesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  def index
    @deliveries = @project.deliveries
  end

  def new
    @delivery = @project.deliveries.new(params[:delivery])
  end
  
  def create
    @delivery = @project.deliveries.new(params[:delivery])
    if @delivery.save
      flash[:notice] = "Delivery created"
      redirect_to project_path(@project)
    else
      flash[:error] = "Unable to create delivery"
      render :action => "new"
    end
  end
  
  def edit
    @delivery = @project.deliveries.find(params[:id])
  end
  
  def update
    @delivery = @project.deliveries.find(params[:id])
    if @delivery.update_attributes(params[:delivery])
      flash[:notice] = "Delivery updated"
      redirect_to project_path(@project)
    else
      flash[:error] = "Unable to update delivery"
      render :action => "edit"
    end
  end
  
  def destroy
    @delivery = @project.deliveries.find(params[:id])
    @delivery.destroy
    flash[:notice] = "Delivery destroyed"
    redirect_to project_path(@project)
  end
end
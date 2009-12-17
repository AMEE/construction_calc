class EnergyConsumptionsController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  def index
    @energy_consumptions = @project.energy_consumptions.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def new
    @energy_consumption = @project.energy_consumptions.new(params[:energy_consumption])
  end
  
  def create
    @energy_consumption = @project.energy_consumptions.new(params[:energy_consumption])
    if @energy_consumption.save
      flash[:notice] = "Energy consumption created"
    else
      flash[:error] = ["Unable to create energy consumption"] + @energy_consumption.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def edit
    @energy_consumption = @project.energy_consumptions.find(params[:id])
  end
  
  def update
    @energy_consumption = @project.energy_consumptions.find(params[:id])
    if @energy_consumption.update_attributes(params[:energy_consumption])
      flash[:notice] = "Energy Consumption updated"
    else
      flash[:error] = ["Unable to update energy consumption"] + @energy_consumption.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def destroy
    @energy_consumption = @project.energy_consumptions.find(params[:id])
    @energy_consumption.destroy
    flash[:notice] = "Energy Consumption destroyed"
    redirect_to project_path(@project)
  end
end
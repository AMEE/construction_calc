class WastesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  def index
    @wastes = @project.wastes.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def new
    @waste = @project.wastes.new(params[:waste])
  end
  
  def create
    @waste = @project.wastes.new(params[:waste])
    if @waste.save
      flash[:notice] = "Waste management created"
    else
      flash[:error] = ["Unable to create waste management"] + @waste.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def edit
    @waste = @project.wastes.find(params[:id])
  end
  
  def update
    @waste = @project.wastes.find(params[:id])
    if @waste.update_attributes(params[:waste])
      flash[:notice] = "Waste updated"
    else
      flash[:error] = ["Unable to update waste management"] + @waste.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def destroy
    @waste = @project.wastes.find(params[:id])
    @waste.destroy
    flash[:notice] = "Waste Management destroyed"
    redirect_to project_path(@project)
  end
end
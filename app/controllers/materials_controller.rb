class MaterialsController < ApplicationController
  
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:index, :show]
  before_filter :ensure_project_writeable_by_user, :except => [:index, :show]
  
  def index
    @materials = @project.materials.paginate :page => params[:page], :order => 'created_at DESC'
  end

  def new
    @material = @project.materials.new(params[:material])
  end
  
  def create
    @material = @project.materials.new(params[:material])
    if @material.save
      flash[:notice] = "Material created"
    else
      flash[:error] = ["Unable to create material"] + @material.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def edit
    @material = @project.materials.find(params[:id])
  end
  
  def update
    @material = @project.materials.find(params[:id])
    if @material.update_attributes(params[:material])
      flash[:notice] = "Material updated"
    else
      flash[:error] = ["Unable to update material"] + @material.errors.full_messages
    end
    redirect_to project_path(@project)
  end
  
  def destroy
    @material = @project.materials.find(params[:id])
    @material.destroy
    flash[:notice] = "Material destroyed"
    redirect_to project_path(@project)
  end
end
class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  
  before_filter :find_client
  
  filter_parameter_logging :password, :password_confirmation
  helper :all
  protect_from_forgery
  
  protected
  # Hard-coded for now, could be nice to do as subdomains in SaaS model
  def find_client
    @client = Client.first
  end
  
  def find_project
    @project = @client.projects.find(params[:project_id])
  end
  
  def ensure_project_readable_by_user
    raise ActiveRecord::RecordNotFound unless current_user.can_read?(@project)
  end
  # TODO throw something else and treat as 404
  def ensure_project_writeable_by_user
    raise ActiveRecord::RecordNotFound unless current_user.can_write?(@project)
  end
end

# TODO:
# cap and cap-multistaging
# amee gem version, json so faster
# Go through auth system and specs for

# AMEE badly documented:
# - data/profile category
# - metadata
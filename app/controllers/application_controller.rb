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

  def ensure_project_writeable_by_user
    raise ActiveRecord::RecordNotFound unless current_user.can_write?(@project)
  end
end

# TODO do other types
# TODO notes in project.rb
# TODO re-read paper docs - check got all requirements covered
# TODO is way to have include out of models?
# TODO auth errors throw something else and treat as 404
# TODO create two in a minute - will it blow up??  Yes
# TODO user.rb TODO items
# TODO write tests for access rights and test myself
# TODO type mappings, not available = can't have, recycle/dispose types
# TODO work on UI
# TODO cap and cap-multistaging
# TODO amee gem version, json so faster
# TODO Go through auth system and specs for
# TODO front page needs to warn if no JS (can view but not create)

# TODO meeting notes:
#   - Assumptions on types
#       What to use for freight train
#       LGV, HGV, articulated classifications - differences and mappings
#       waste mappings
#       material assumptions + missing two
#   - Also we need to decide units everything specified in

# AMEE badly documented:
# - data/profile category
# - metadata
# - no docs on type, limits and validations
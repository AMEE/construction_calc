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

# TODO notes in project.rb
# TODO re-read paper docs - check got all requirements covered
# TODO is way to have include out of models?
# TODO auth errors throw something else and treat as 404
# TODO create two in a minute - will it blow up??  Yes
# TODO user.rb TODO items
# TODO whole user access/creation area - can use system use by unboxed and others for admin?
# TODO write tests for access rights and test myself
# TODO type mappings, not available = can't have, recycle/dispose types
# TODO work on UI
# TODO cap and cap-multistaging
# TODO amee gem version, json so faster
# TODO Go through auth system and specs for
# TODO front page needs to warn if no JS (can view but not create)

# - Assumptions on types
#     What to use for freight train?
#     LGV, HGV, articulated classifications - will be updated (email Andy)
#     materials - notes in model
#     waste mappings [+ do create, update, delete, check AMEE stored data test as can't do for this atm]
# - Also we need to check units everything specified in make sense (eg liquid petrol and gas measured in same?) [some hints in dynamic50 stories]
# 
# Had to cache carbon data for each item and purge at weekend when plenty of time
# Can't cache by category as transport spans multiple classes = major fail
# Other factors paging through results and manual ask for carbon value each time update or delete

# AMEE badly documented:
# - data/profile category
# - metadata
# - no docs on type, limits and validations
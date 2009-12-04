class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  
  before_filter :find_client
  
  filter_parameter_logging :password, :password_confirmation
  helper :all
  protect_from_forgery
  rescue_responses['NotAllowed'] = :not_found
  
  protected
  # Hard-coded for now, could be nice to do as subdomains in SaaS model
  def find_client
    @client = Client.first
  end
  
  def find_project
    @project = @client.projects.find(params[:project_id])
  end
  
  def admin_or_client_admin_required
    current_user.admin? || current_user.client_admin?(@client)
  end
  
  def ensure_project_readable_by_user
    raise NotAllowed unless current_user.can_read?(@project)
  end

  def ensure_project_writeable_by_user
    raise NotAllowed unless current_user.can_write?(@project)
  end
end

# TODO project validations
# TODO once created project, need to add user
# TODO requirements - reporting, calculations per floor area etc.  Do need?
# TODO chase data in amee as depending how done can hold up (mappings area) + client choose units
# TODO is way to have include out of models?
# TODO create two in a minute - blows up like a volcano.  Can used named items apparently (speak to Paul)
# TODO user.rb TODO items
# TODO write tests for access rights.  Also go through auth system and specs for (made changes)
# TODO flash messages and model error methods
# TODO work on UI
# TODO cap and cap-multistaging
# TODO amee gem version, json so faster
# TODO front page needs to warn if no JS (can view but not create)
# TODO test not-allowed 404s in prod

# - Assumptions on types
#     What to use for freight train?
#     LGV, HGV, articulated classifications - will be updated (email Andy)
#     materials - notes in model
#     waste mappings [+ do create, update, delete, check AMEE stored data test as can't do for this atm]
#       also this has recycle/dispose which is a big requirement depending how implemented in AMEE
#       looks like want volume for material.  Is that possible?
# - Also we need to check units everything specified in make sense (eg liquid petrol and gas measured in same?) [some hints in dynamic50 stories]
# 
# Had to cache carbon data for each item and purge at weekend when plenty of time
# Can't cache by category as transport spans multiple classes = major fail
# Other factors paging through results and manual ask for carbon value each time update or delete

# AMEE badly documented:
# - data/profile category
# - metadata
# - no docs on type, limits and validations
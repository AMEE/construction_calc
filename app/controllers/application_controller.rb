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
    raise NotAllowed unless current_user.admin? || current_user.client_admin?(@client)
  end
  
  def ensure_project_readable_by_user
    raise NotAllowed unless current_user.can_read?(@project)
  end

  def ensure_project_writeable_by_user
    raise NotAllowed unless current_user.can_write?(@project)
  end
end

# TODO when new/edit for a type and it fails doesn't show form [can sort this somehow].  Also when creating new
#      adds an item should show list.  Can do all this with JS somehow - eg on success render partial list
# TODO password reset, roles, users screens, rest of types

# TODO test changing unit type on one where type depends on selection in dropdown 
# TODO powered by amee logo
# TODO IE7 is the critical one
# TODO destroy project
# TODO pull out main UI page into partials
# TODO google_chart_image in project tidy up
# TODO on profile create add /metadata to profile with UK country (even though default)
# TODO project - start date, when start project or enter as field?
# TODO project limit 10 per client??
# TODO is way to have include out of models?
# TODO signup, password reset emails text
# TODO create two in a minute - blows up like a volcano.  Can used named items apparently (speak to Paul)
# TODO amee gem version, json so faster
# TODO requirements - reporting, calculations per floor area etc.  Do need?
# TODO cap and cap-multistaging, cronjob for purging cache
# TODO front page needs to warn if no JS (can view but not create) - actually needed for all site
# TODO test not-allowed 404s in prod
# TODO will have recycle/dispose option issue for waste
# TODO write tests for access rights - see RolesControllerSpec for progress

# - Assumptions on types
#     What to use for freight train?
#     LGV, HGV, articulated classifications - will be updated (email Andy)
#     materials - notes in model
#     waste mappings [+ do create, update, delete, check AMEE stored data test as can't do for this atm]
#       also this has recycle/dispose which is a big requirement depending how implemented in AMEE
#       looks like want volume for material.  Is that possible?
# - Also we need to check units everything specified in make sense (eg liquid petrol and gas measured in same?) [some hints in dynamic50 stories]


# Had to cache carbon data for each item and purge at weekend when plenty of time
# Can't cache by category as transport spans multiple classes = major fail
# Other factors paging through results and manual ask for carbon value each time update or delete
#
# AMEE badly documented:
# - data/profile category
# - metadata
# - no docs on type, limits and validations
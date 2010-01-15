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

# Dev actions:
# plastic conversion, what to do about marble tiles
# - do sample weight<->volume conversion
# - labeling on fields (+ check that email)
# - asbestos exception
# - await volume to weight conversions from Overbury [overbury]
# - recycled content for materials? Check ICE. Carpet from Interface. [jamie]

# TODO email from local server - seems to work but should check how it's working [check SPF etc]
# TODO write up wiki page
# TODO setup amee.yml info needed to run against production.  Also settings.yml
# TODO any more wiki notes: https://sites.google.com/a/amee.cc/knowledge-base/home/overbury
# TODO write tests for access rights - see RolesControllerSpec for progress

# Leasons learnt:
#  - need to get client category <-> amee categories mapped out up front
#  - storing of data in amee (wasted some time trying to do this, now know but would be nice to have custom variable support)
#  - UI would speed things up a little (not so much in terms of HTML but more in terms of getting more project throughput)
#  - Reusable on two levels - should run through libs with other rails guys
#  - Can knock these out quite quickly if had UI dude (with potential reusable components - althought depends how, is reusable on two levels though)
#  - AJAX can slow things up when time is tight
#  - AMEE badly documented:
#     - data/profile category
#     - metadata
#     - no docs on type, limits and validations
#  - feedback for me
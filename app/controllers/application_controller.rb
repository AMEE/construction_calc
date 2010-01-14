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

# Assumptions not approved by Overbury yet:
# - ceiling tiles are split into metal and mineral fibre in materials
# - carpet tiles waste are general waste carbon output
# - concrete and bricks waste are general waste carbon output
# - plasterboard waste are general waste carbon output
# - asbestos waste are general waste carbon output
# - septic tank waste is organic waste carbon output
# - Is cans using the best category (note if new category divides carbon output by 3 or more then may need to change to plastic bottles)
# 
# Assumptions not approved but will change in new year when science can do more research anyway:
# - Train is fixed at 1 tonne weight (and I'm not sure if this includes train itself - waiting on science)
# - Fluorescent tubes waste mapped to general waste
# - Paint and adhesive waste mapped to general waste
# - Raised floor tiles mapped to general waste
# - Fridge gas - gas HFC-134a for now

# * make name field allow space [ask Jamie for example?]
# * await volume to weight conversions from Overbury [overbury]
# * recycled content for materials? Check ICE. Carpet from Interface. [jamie]

# TODO email from local server - seems to work but should check how it's working [check SPF etc]
# TODO write up wiki page
# TODO setup amee.yml info needed to run against production.  Also settings.yml
# TODO any more wiki notes: https://sites.google.com/a/amee.cc/knowledge-base/home/overbury
# TODO write tests for access rights - see RolesControllerSpec for progress

# Leasons learnt:
#  - AJAX can slow things up when time is tight
#  - need to get client category to amee categories mapped out up front
#  - storing of data in amee (wasted some time trying to do this, now know but would be nice to have custom variable support)
#  - UI would sped things up a little (not so much in terms of HTML but more in terms of getting more project throughput)
#  - Can knock these out quite quickly if had UI dude with potential reusable components
#
# AMEE badly documented:
# - data/profile category
# - metadata
# - no docs on type, limits and validations
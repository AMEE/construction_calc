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

# TODO unapproved assumptions: 
#       - ceiling tiles split into metal and mineral fibre in materials
#       - combined paper&card in waste
#       - split out ferrous&non-ferrous metals in waste
#       - split out cans and bottles in waste
#       - Train 1tonne fixed weight (no idea if this includes train itself)
#       - fluorescent tubes waste, Paint and adhesive waste, raised floor tiles all mapped to general waste for now
#       - fridge gas - gas HFC-134a

# TODO front page needs to warn if no JS support in browser
# TODO 100% height causing a problem when ajax expands to be greater than window height
# TODO change units first it goes back to default if then change waste type option
# TODO decide on footer blurb
# TODO calendar got white bit on bottom in IE.  Demo on their site works fine though, so must be some overbury css code
# TODO signup, password reset emails text

# TODO bug report
# TODO on profile create add /metadata to profile with UK country (even though default)
# TODO is way to have include out of models?
# TODO have possible... - good idea?  Note on method if ok to override.  Also is better way to do this?
# TODO extend additional options to update?
# TODO Also we need to check units everything specified in make sense (eg liquid petrol and gas measured in same?) [some hints in dynamic50 stories]
# TODO reporting pdf
# TODO when new/edit for a type and it fails doesn't show form [can sort this somehow].  Also when creating new
#      adds an item should show list.  Can do all this with JS somehow - eg on success render partial list

# TODO write up wiki page
# TODO email from local server - seems to work but should check how it's working
# TODO setup amee.yml info needed to run against production
# TODO any more wiki notes: https://sites.google.com/a/amee.cc/knowledge-base/home/overbury
# TODO write tests for access rights - see RolesControllerSpec for progress
# TODO Assumptions on types
#      What to use for freight train?
#      materials - ceiling tile data
#      looks like want volume for material.  Is that possible?
#      waste mappings

# Leasons learnt:
#  - AJAX can slow things up when time is tight
#  - need to get client category to amee categories mapped out up front
#
# AMEE badly documented:
# - data/profile category
# - metadata
# - no docs on type, limits and validations
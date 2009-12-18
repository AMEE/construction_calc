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
# TODO remove config/database.yml if dig hasn't already
# TODO will have recycle/dispose option issue for waste.  Need to do whole of waste section in fact - could just pull out into controller
#      + do create, update, delete, check AMEE stored data test as can't do for this atm.  Also column headings for index
# TODO IE7 will need more work
# TODO project - start date, when start project or enter as field?
# TODO project limit 10 per client??
# TODO material - in volume?
# TODO create two in a minute - blows up like a volcano.  Can used named items apparently (speak to Paul)
# TODO test and make sure going into AMEE correctly
# TODO cronjob
# TODO requirements - reporting, calculations per floor area etc.  Do need?  Don't think so but need pdf
# TODO cap and cap-multistaging
# TODO UAT - want assumptions sending to them?  Also have unapproved assumptions

# TODO when new/edit for a type and it fails doesn't show form [can sort this somehow].  Also when creating new
#      adds an item should show list.  Can do all this with JS somehow - eg on success render partial list
# TODO password reset, roles, users screens

# TODO powered by amee logo
# TODO 100% height causing a problem when ajax expands to be greater than window height
# TODO edit, delete buttons have spacing on table index
# TODO destroy project
# TODO pull out main UI page into partials
# TODO on profile create add /metadata to profile with UK country (even though default)
# TODO is way to have include out of models?
# TODO signup, password reset emails text
# TODO write up wiki page
# TODO running against staging server still?  Will break materials if move ot prod?
# TODO Also we need to check units everything specified in make sense (eg liquid petrol and gas measured in same?) [some hints in dynamic50 stories]
# TODO front page needs to warn if no JS (can view but not create) - actually needed for all site
# TODO test not-allowed 404s in prod
# TODO write tests for access rights - see RolesControllerSpec for progress

# - Assumptions on types
#     What to use for freight train?
#     materials - ceiling tile data
#     looks like want volume for material.  Is that possible?
#     waste mappings

# Leasons learnt:
#  - AJAX can slow things up when time is tight
#  - need to get client category to amee categories mapped out up front
#
# AMEE badly documented:
# - data/profile category
# - metadata
# - no docs on type, limits and validations
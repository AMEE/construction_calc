class RootController < ApplicationController  
  before_filter :login_required

  # This is just convenience action that redirects
  def index
    projects = @client.projects.readable_by_user(current_user)
    if projects.size > 0
      redirect_to project_path(projects.first)
    elsif current_user.admin? || current_user.client_admin?(@client)
      flash[:error] = "There are no projects that you have permissions to read"
      redirect_to new_project_path
    else
      logout_killing_session!
      flash[:error] = "You don't have access to any projects.  Contact your administrator"
      redirect_to login_path
    end
  end
end
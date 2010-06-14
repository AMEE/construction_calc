class RootController < ApplicationController  
  before_filter :login_required

  # This is just convenience action that redirects
  def index
    projects = @client.projects.readable_by_user(current_user)
    if projects.size > 0
      redirect_to project_path(projects.first)
    elsif current_user.admin? || current_user.client_admin?(@client)
      flash[:info] = [
        "Welcome to the Construction Calculator!",
        "&nbsp;",
        "The Construction Calculator allows you to create a number of
        construction projects, each with their own set of users that can log in
        and either view and/or update the data stored.",
        "&nbsp;",
        "To get started, you need to create a new construction project. Please
        enter a new project name below, and the start date for the project."
      ]
      redirect_to new_project_path
    else
      logout_killing_session!
      flash[:error] = "You don't have access to any projects. Contact your administrator."
      redirect_to login_path
    end
  end
end
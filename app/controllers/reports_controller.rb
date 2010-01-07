class ReportsController < ApplicationController
  before_filter :login_required
  before_filter :find_project
  before_filter :ensure_project_readable_by_user, :only => [:create]
  
  def create
    # Nothing required here
  end
end
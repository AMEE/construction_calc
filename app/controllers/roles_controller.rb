class RolesController < ApplicationController
  
  before_filter :login_required
  before_filter :find_user
  before_filter :check_user_allowed_to_view_roles, :only => [:index, :new]
  before_filter :check_user_allowed_to_create_role, :only => [:create]
  before_filter :check_user_allowed_to_destroy_role, :only => [:destroy]
  
  def index
    @roles = @user.roles.accessible_by_user(current_user)
  end
  
  def new
    @role = @user.roles.new
  end
  
  def create
    @role = @user.roles.new(params[:role].merge({:allowable_type => "Project"}))
    if !@role.save
      respond_to do |format|
        format.html {redirect_to user_roles_path(@user)}
        format.js {render}
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = "Error assigning roles"
          redirect_to user_roles_path(@user)
        }
        format.js {render(:create_error)}
      end
    end
  end
  
  def destroy
    @role = @user.roles.find(params[:id])
    @role.destroy
  end
  
  private
  def find_user
    @user = User.find(params[:user_id])
  end
  
  def check_user_allowed_to_view_roles
    raise NotAllowed unless @client.associated_users_readable_by(current_user).include?(@user)
  end
  
  def check_user_allowed_to_destroy_role
    raise NotAllowed if @user == current_user
    raise NotAllowed unless @client.associated_users_readable_by(current_user).include?(@user)
    raise NotAllowed unless @user.roles.accessible_by_user(current_user).include?(Role.find(params[:id]))
  end
  
  def check_user_allowed_to_create_role
    raise NotAllowed unless current_user.can_assign_role?(params[:role])
    raise NotAllowed unless current_user.can_assign_project_to_client?(@client, params[:role])
  end
end
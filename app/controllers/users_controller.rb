class UsersController < ApplicationController
  
  # Protect these actions behind an admin login
  before_filter :login_required
  before_filter :find_user, :only => [:edit, :update, :destroy]
  before_filter :ensure_current_user, :only => [:edit, :update]
  before_filter :ensure_can_create_other_users, :only => [:new]
  before_filter :ensure_allowed_to_create_user, :only => [:create]
  before_filter :admin_or_client_admin_required, :only => [:destroy]
  
  def index
    @users = @client.associated_users_readable_by(current_user)
  end
  
  def new
    @user = User.new
    @user.roles.build
  end
 
  def create
    @user = User.new(user_and_role_params)
    @user.register! && @user.activate! if @user.valid?
    if @user.valid? && @user.errors.empty?
      flash[:notice] = "Account created"
      redirect_to user_roles_path(@user)
    else
      flash[:error]  = "We couldn't set up that account"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "User profile updated"
    else
      flash[:error] = "Error updating profile"
    end
    render :action => "edit"
  end
  
  def destroy
    @user.destroy
    redirect_to users_path
  end

  protected
  def find_user
    @user = User.find(params[:id])
  end
  
  def ensure_current_user
    raise NotAllowed if @user != current_user
  end
  
  def ensure_can_create_other_users
    raise NotAllowed unless current_user.can_create_other_users?
  end
  
  def ensure_allowed_to_create_user
    raise NotAllowed unless current_user.can_assign_role?(params[:user][:roles_attributes]["0"])
    raise NotAllowed unless current_user.can_assign_project_to_client?(@client, params[:user][:roles_attributes]["0"])
  end
  
  def user_and_role_params
    params[:user][:roles_attributes]["0"].merge!(:allowable_type => "Project")
    params[:user]
  end
end
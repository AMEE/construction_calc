class PasswordsController < ApplicationController

  def new
    @password = Password.new
    
    respond_to do |format|
      format.html
    end
  end

  def create
    @password = Password.new(params[:password])
    @password.user = User.find_by_email(@password.email)
    
    respond_to do |format|
      if @password.save
        flash[:notice] = "A link to change your password has been sent to #{@password.email}."
        format.html { redirect_to root_path }
      else
        if @password.errors.on(:user)
          @password.errors.clear
          flash[:error] = "We can't find a user with that email. Please check the email address and try again."
        end
        format.html { render :action => "new" }
      end
    end
  end

  def reset
    @user = Password.find(:first, :conditions => ['reset_code = ? and expiration_date > ?', params[:reset_code], Time.now]).user
  rescue
    flash[:notice] = 'The change password URL you visited is either invalid or expired'
    redirect_to(new_password_path)
  end

  def update_after_forgetting
    @password = Password.find_by_reset_code(params[:reset_code])
    @user = @password.user unless @password.nil?
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        @password.destroy
        flash[:notice] = "Password was successfully updated.  Please log in"
        format.html { redirect_to login_path}
      else
        flash[:notice] = 'There was a problem resetting your password.  Please try again'
        format.html { render :action => :reset, :reset_code => params[:reset_code] }
      end
    end
  end  
end
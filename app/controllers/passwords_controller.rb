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
        flash[:notice] = "We've sent an email to you at '#{@password.email}'. Please check your email!"
        format.html { redirect_to root_path }
      else
        if @password.errors.on(:user)
          @password.errors.clear
          flash[:error] = "Sorry, we can't find a user with the email address '#{@password.email}'. Please check your email address and try again."
        end
        format.html { render :action => "new" }
      end
    end
  end

  def reset
    @user = Password.find(:first, :conditions => ['reset_code = ? and expiration_date > ?', params[:reset_code], Time.now]).user
  rescue
    flash[:notice] = 'Sorry, but this change password is either invalid or expired.'
    redirect_to(new_password_path)
  end

  def update_after_forgetting
    @password = Password.find_by_reset_code(params[:reset_code])
    @user = @password.user unless @password.nil?
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        @password.destroy
        flash[:notice] = "Your password was successfully updated. Please log in below!"
        format.html { redirect_to login_path}
      else
        format.html { render :action => :reset, :reset_code => params[:reset_code] }
      end
    end
  end  
end
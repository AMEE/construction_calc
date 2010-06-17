class PasswordMailer < Mailer
  
  def forgot_password(password)
    setup_email(password.user)
    @subject     = "You have requested to change your password"
    @body[:url]  = change_password_url(:host => current_host, :reset_code => password.reset_code)
  end

  def reset_password(user)
    setup_email(user)
    @subject    = 'Your password has been reset.'
    @body[:url] = login_url(:host => current_host)
  end
end
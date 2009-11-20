class UserMailer < Mailer
  def signup_notification(user)
    setup_email(user)
    @subject     = 'Please activate your new account'
    @body[:url]  = activate_url(:host => APP_CONFIG[:site_host], :activation_code => user.activation_code)
  end
  
  def activation(user)
    setup_email(user)
    @subject     = 'Your account has been activated!'
    @body[:url]  = root_url(:host => APP_CONFIG[:site_host])
  end
end
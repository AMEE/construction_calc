class UserMailer < Mailer
  def signup_notification(user)
    setup_email(user)
    @subject          = 'Your #{APP_CONFIG[:site_name]} account'
    @body[:url]       = root_url(:host => APP_CONFIG[:site_host])
    @body[:password]  = user.password
  end
end
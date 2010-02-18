class UserMailer < Mailer
  def signup_notification(user)
    setup_email(user)
    @subject          = "Your AMEE monthly calculator account"
    @body[:url]       = root_url(:host => current_host)
    @body[:password]  = user.password
  end
end
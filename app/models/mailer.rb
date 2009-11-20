class Mailer < ActionMailer::Base
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = APP_CONFIG[:noreply_email]
    @reply_to    = APP_CONFIG[:noreply_email]
    headers 'Return-Path' => APP_CONFIG[:noreply_email]
    @sent_on     = Time.now
    @body[:user] = user
  end
end
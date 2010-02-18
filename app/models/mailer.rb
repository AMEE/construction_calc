class Mailer < ActionMailer::Base
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "help@amee.com"
    @reply_to    = "help@amee.com"
    headers 'Return-Path' => "help@amee.com"
    @sent_on     = Time.now
    @body[:user] = user
  end
  
  def current_host
    if defined?(MyAmee::CurrentHost)
      MyAmee::CurrentHost.get
    else
      YAML.load_file("#{RAILS_ROOT}/config/settings.yml")[RAILS_ENV].symbolize_keys[:site_host]
    end
  end
end
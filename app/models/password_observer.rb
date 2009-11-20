class PasswordObserver < ActiveRecord::Observer
  def after_create(password)
    PasswordMailer.deliver_forgot_password(password)
  end

  def after_destroy(password)
    PasswordMailer.deliver_reset_password(password.user)
  end
end
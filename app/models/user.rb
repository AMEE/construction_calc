require 'digest/sha1'

class User < ActiveRecord::Base
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message
  validates_length_of       :name,     :maximum => 100
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  attr_protected :crypted_password, :salt, :remember_token, :remember_token_expires_at,
    :activation_code, :activated_at, :state, :deleted_at
    
  has_many :roles do
    def admin
      find_by_role_type(Role::Type::SUPER_ADMIN)
    end
    def company_admins
      find_all_by_role_type(Role::Type::COMPANY_ADMIN)
    end
    def project_owners
      find_all_by_role_type(Role::Type::PROJECT_OWNER)
    end
    def readers
      find_all_by_role_type(Role::Type::READER)
    end
  end

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login.downcase}
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def admin?
    !roles.admin.nil?
  end
  
  def client_admin?(client)
    roles.company_admins.map {|r| r.allowable}.include?(client)
  end
  # TODO common code/tidy up
  def can_read?(object)
    if can_write?(object)
      return true
    elsif object.is_a?(Project)
      roles.readers.map {|r| r.allowable}.include?(object)
    end
    
    return false
  end
  # TODO write tests for code added here
  def can_write?(object)
    return true if admin?
    
    if object.is_a?(Client)
      roles.company_superusers.map {|r| r.allowable}.include?(object)
    elsif object.is_a?(Project)
      roles.company_admins.map {|r| r.allowable.projects}.flatten.include?(object) ||
        roles.project_owners.map {|r| r.allowable}.include?(object)
    else
      false
    end
  end

  protected
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
end
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
  
  has_many :roles, :dependent => :destroy do
    def admin
      find_by_role_type(Role::Type::SUPER_ADMIN)
    end
    def client_admins
      find_all_by_role_type(Role::Type::CLIENT_ADMIN)
    end
    def project_owners
      find_all_by_role_type(Role::Type::PROJECT_OWNER)
    end
    def readers
      find_all_by_role_type(Role::Type::READER)
    end
    def accessible_by_user(user)
      find(:all).select {|r| user.can_access_role?(r)}
    end
  end
  accepts_nested_attributes_for :roles, :reject_if => proc {|attributes| !attributes['user_id'].blank?}

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
  
  # Permission stuff
  def admin?
    !roles.admin.nil?
  end
  
  def clients_admin
    roles.client_admins.map {|r| r.allowable}
  end
  
  def projects_own
    roles.project_owners.map {|r| r.allowable}
  end
  
  def projects_read
    roles.readers.map {|r| r.allowable}
  end
  
  def client_admin?(client)
    clients_admin.include?(client)
  end
  
  def project_owner?(project)
    projects_own.include?(project)
  end
  
  def a_project_owner?
    projects_own.size > 0
  end
  
  def project_reader?(project)
    projects_read.include?(project)
  end
  
  def role_types_can_assign
    if admin? || clients_admin.size > 0
      [Role::Type::PROJECT_OWNER, Role::Type::READER]
    elsif a_project_owner?
      [Role::Type::READER]
    else
      []
    end
  end
  
  def can_create_other_users?
    role_types_can_assign.size > 0
  end
  
  def can_access_role?(role)
    return true if admin? || role.user == self
    
    if (role.allowable.is_a?(Client))
      client_admin?(role.allowable)
    elsif (role.allowable.is_a?(Project))
      if project_owner?(role.allowable)
        true
      elsif project_reader?(role.allowable)
        role.role_type == Role::Type::READER
      else
        client_admin?(role.allowable.client)
      end
    end
  end
  
  def can_assign_role?(role_attrs)
    role_types_can_assign.include?(role_attrs[:role_type])
  end
  
  def allowed_to_assign_project_to_client?(client, role_attrs)
    client.projects_assignable_by(self).include?(Project.find(role_attrs[:allowable_id]))
  end
  
  def can_read?(object)
    if can_write?(object)
      return true
    elsif object.is_a?(Project)
      project_reader?(object)
    end
    
    return false
  end

  def can_write?(object)
    return true if admin?
    
    if object.is_a?(Client)
      client_admin?(object)
    elsif object.is_a?(Project)
      clients_admin.include?(object.client) || project_owner?(object)
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
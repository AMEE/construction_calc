class Client < ActiveRecord::Base
  
  validates_length_of :name, :maximum => 100
  validates_format_of :name, :with => /\A[\w -]+\Z/, :message => "Name must be letters, numbers or underscores only"
  
  has_many :roles, :as => :allowable, :dependent => :destroy
  has_many :projects do
    def readable_by_user(user)
      find(:all).select {|p| user.can_read?(p)}
    end
  end
  
  PROJECT_LIMIT = 10
  
  def associated_users_readable_by(viewing_user)
    if viewing_user.admin? || viewing_user.client_admin?(self)
      (associated_client_admins + associated_projects_users).uniq
    elsif viewing_user.roles.project_owners.size > 0
      users_from_projects_owned_by(viewing_user)
    else
      [viewing_user]
    end
  end
  
  def projects_assignable_by(viewing_user)
    if viewing_user.admin? || viewing_user.client_admin?(self)
      projects
    else
      viewing_user.projects_own
    end
  end
  
  private
  def associated_client_admins
    roles.map{|r| r.user}
  end
  
  def associated_projects_users
    projects_roles.map{|r| r.user} 
  end
  
  def users_from_projects_owned_by(user)
    projects_roles.select {|r| user.project_owner?(r.allowable)}.map {|u| u.user}.uniq
  end
  
  def projects_roles
    projects.map {|p| p.roles}.flatten
  end
end
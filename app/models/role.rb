class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :allowable, :polymorphic => true # TODO rename I think: refs in client and project and of course DB
  
  validates_uniqueness_of :role_type, :scope => [:user_id, :allowable_id, :allowable_type], :message => "Access right for this Role and Project already exists"
  
  module Type
    SUPER_ADMIN = "super_admin"
    CLIENT_ADMIN = "client_admin"
    PROJECT_OWNER = "project_owner"
    READER = "reader"
  end
end
class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :allowable, :polymorphic => true # TODO rename I think: refs in client and project and of course DB
  
  module Type
    SUPER_ADMIN = "super_admin"
    COMPANY_ADMIN = "company_admin"
    PROJECT_OWNER = "project_owner"
    READER = "reader"
  end
end
include AuthenticatedTestHelper

def setup_initial_project_and_client
  @project = Factory.build(:project)
  @project.stub!(:amee_create).and_return(true)
  @project.save
  @client = @project.client
end

def project(client)
  project = Factory.build(:project, :client => client)
  project.stub!(:amee_create).and_return(true)
  project.save
  project
end

def super_admin_user
  user = Factory(:user)
  user.roles << Factory(:role, :role_type => Role::Type::SUPER_ADMIN)
  user
end

def project_owning_user(project)
  user = Factory(:user)
  user.roles << Factory(:role, :role_type => Role::Type::PROJECT_OWNER, :allowable => project)
  user
end

def reader_user(project)
  user = Factory(:user)
  user.roles << Factory(:role, :role_type => Role::Type::READER, :allowable => project)
  user
end
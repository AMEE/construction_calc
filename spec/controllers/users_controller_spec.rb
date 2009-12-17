require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do

  before(:each) do
    setup_initial_project_and_client
    @user = super_admin_user
    login_as(@user)
  end

  describe "the user index page" do
    it "should render a list of users" do
      get :index
      response.should be_success
    end
  end

  describe "the new user page" do
    it "should render the page if a role type and allowable are specified" do
      @project2 = project(@client)
      get :new, :roles_attributes => {"0" => {:role_type => Role::Type::READER, :allowable_id => @project2.id}}
      response.should be_success
    end
    
    it "should require a user who is permitted to create other users" do
      get :new
      response.should be_success
    end
    
    it "should raise an error if the user isn't permitted to create other users" do
      lambda {
        @reader = reader_user(@project)
        login_as(@reader)
        get :new
      }.should raise_error(NotAllowed)
    end
  end

  describe 'on signup' do
    it "should ensure creating user can assign role level" do
      lambda {
        @reader = reader_user(@project)
        login_as(@reader)
        create_user
      }.should raise_error(NotAllowed)
    end
    
    it "should ensure creating user can assign project to client" do
      lambda {
        @project2 = project(@client)
        @project_owning_user = project_owning_user(@project2)
        login_as(@project_owning_user)
        create_user
      }.should raise_error(NotAllowed)
    end
    
    it "should require a user to be logged in" do
      login_as(nil)
      create_user
      response.should redirect_to(login_path)
    end

    it 'should be successful if all fields are present' do
      lambda do
        create_user
        response.should be_redirect
      end.should change(User, :count).by(1)
    end

    it 'should require a login field' do
      lambda do
        create_user(:login => nil)
        assigns[:user].errors.on(:login).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end
  
    it 'should require a password field' do
      lambda do
        create_user(:password => nil)
        assigns[:user].errors.on(:password).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end
  
    it 'should require a password confirmation field' do
      lambda do
        create_user(:password_confirmation => nil)
        assigns[:user].errors.on(:password_confirmation).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end

    it 'should require an email field' do
      lambda do
        create_user(:email => nil)
        assigns[:user].errors.on(:email).should_not be_nil
        response.should be_success
      end.should_not change(User, :count)
    end
  
    it "should create a role for the user" do
      create_user
      User.find_by_login("quire").roles.first.role_type.should == Role::Type::PROJECT_OWNER
      User.find_by_login("quire").roles.first.allowable.should == @project
    end
  end
  
  describe "the edit user page" do
    it "should render the edit profile form" do
      get :edit, :id => @user.id
      response.should be_success
    end
    
    it "should not render the page if the viewing user doesn't own the page" do
      lambda {
        @user2 = reader_user(@project)
        get :edit, :id => @user2.id
      }.should raise_error(NotAllowed)
    end
  end
  
  describe "the update user page" do
    it "should render after updating" do
      put :update, :id => @user.id, :user => {:email => "newemail"}
      response.should be_success
    end
    
    it "should not render the page if the viewing user doesn't own the page" do
      lambda {
        @user2 = reader_user(@project)
        get :edit, :id => @user2.id
      }.should raise_error(NotAllowed)
    end
  end
  
  describe "the destroy user action" do
    it "should redirect after deleting a user" do
      @user2 = reader_user(@project)
      delete :destroy, :id => @user2.id
      response.should redirect_to(users_path)
    end
    
    it "should not allow a user to delete themselves" do
      lambda {
        delete :destroy, :id => @user.id
      }.should raise_error(NotAllowed)
    end
    
    it "should not allow a project owner to delete a user" do
      lambda {
        @user2 = project_owning_user(@project)
        login_as(@user2)
        delete :destroy, :id => @user.id
      }.should raise_error(NotAllowed)
    end
    
    it "should not allow a reader to delete a user" do
      lambda {
        @user2 = reader_user(@project)
        login_as(@user2)
        delete :destroy, :id => @user.id
      }.should raise_error(NotAllowed)
    end
  end
  
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69',
      :roles_attributes => {"0" => {:role_type => Role::Type::PROJECT_OWNER, 
      :allowable_id => @project}} }.merge(options)
  end
end
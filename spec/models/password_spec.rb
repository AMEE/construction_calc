require 'spec_helper'

describe Password do
  fixtures :users
  
  before(:each) do
    user_email = "salty_dog@example.com"
    @valid_attributes = {
      :email => user_email,
      :user => User.find_by_email(user_email)
    }
  end

  it "should create a new instance given valid attributes" do
    Password.create!(@valid_attributes)
  end
end

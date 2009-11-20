require File.dirname(__FILE__) + '/../spec_helper'

describe Role do
  describe "associations" do
    it { should belong_to(:user) }
  end
end
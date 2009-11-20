require 'spec_helper'

describe Commute do
    
  before(:each) do
  end

  describe "associations" do
    it { should belong_to(:project) }
  end
end
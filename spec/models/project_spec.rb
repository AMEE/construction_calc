require 'spec_helper'

describe Project do
    
  before(:each) do
  end

  describe "associations" do
    it { should belong_to(:client) }
    it { should have_many(:commutes) }
  end
end
require 'spec_helper'

describe Client do
    
  before(:each) do
  end

  describe "associations" do
    it { should have_many(:projects) }
  end
end
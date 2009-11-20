class Delivery < ActiveRecord::Base
  
  TYPE = {
    :van => AmeeCategory.new("Van", :distance, "/transport/van/generic", :fuel => "diesel (by size class)", :size => "1.305 to 1.740 tonnes"),
    
    # Need clarification on these from client
    :lgv => AmeeCategory.new("LGV", :distance, "/transport/motorcycle/generic", :fuel => "petrol", :size => "medium"),
    :hgv => AmeeCategory.new("HGV", :distance, "/transport/car/generic", :fuel => "petrol", :size => "medium"),
    :lorry => AmeeCategory.new("Articulated Lorry", :distance, "/transport/train/generic", :type => "national"),
    
    # Not sure if freight train right one to use in AMEE due to US data
    :rail => AmeeCategory.new("Rail", :distance, "/transport/train/generic", :type => "underground")
  }
end
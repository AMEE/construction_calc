class Energy < ActiveRecord::Base
  
  TYPE = {
    :electricity => AmeeCategory.new("Electricity", :energy, "/home/energy/quantity", :type => "electricity"),
    :gas => AmeeCategory.new("Gas", :volumable_energy, "/home/energy/quantity", :type => "gas"),
    :diesel => AmeeCategory.new("Diesel", :volumable_energy, "/home/energy/quantity", :type => "diesel"),
    :petrol => AmeeCategory.new("Petrol", :volumable_energy, "/home/energy/quantity", :type => "petrol")
  }
end

class EnergyConsumption < ActiveRecord::Base

  include AmeeCarbonStore
  has_carbon_data_stored_in_amee
  
  # No assumptions on types in this model
  COLOUR = "#CD3A3D"
  TYPE = {
    :electricity => AmeeCategory.new("Electricity", :energy, "/home/energy/quantity", :type => "electricity"),
    :gas => AmeeCategory.new("Gas", :volumable_energy, "/home/energy/quantity", :type => "gas"),
    :diesel => AmeeCategory.new("Diesel", :volumable_energy, "/home/energy/quantity", :type => "diesel"),
    :petrol => AmeeCategory.new("Petrol", :volumable_energy, "/home/energy/quantity", :type => "petrol")
  }
  
  def amee_category
    TYPE[energy_consumption_type.to_sym]
  end
end
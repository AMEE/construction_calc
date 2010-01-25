class Delivery < ActiveRecord::Base
  
  include AmeeCarbonStore
  has_carbon_data_stored_in_amee :type_amount_repeats => true
  
  # Assumptions on types:
  #   - van - diesel, 1.305-1.740 tonnes
  #   - non-articulated lorry - diesel, fixed load
  #   - articulated lorry - diesel, fixed load
  COLOUR = "#FFBA4E"
  TYPE = {
    :van => AmeeCategory.new("Van", :distance, "/transport/van/generic/defra", :fuel => "diesel", :size => "1.305 to 1.740 tonnes"),
    :non_articulated => AmeeCategory.new("Non-Articulated Lorry", :distance, "/transport/lgv/generic/defra", :type => "rigid", :size => "uk average"),
    :articulated => AmeeCategory.new("Articulated Lorry", :distance, "/transport/lgv/generic/defra", :type => "articulated", :size => "uk average")
  }
  
  def amee_category
    TYPE[delivery_type.to_sym]
  end
end
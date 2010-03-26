class Delivery < ActiveRecord::Base
  
  has_carbon_data_stored_in_amee :repetitions => true
  cattr_reader :per_page

  COLOUR = "#FFBA4E"
  TYPE = {
    :van => AmeeCategory.new("Van", :distance, "/transport/van/generic/defra", :fuel => "diesel", :size => "1.305 to 1.740 tonnes"),
    :non_articulated => AmeeCategory.new("Non-Articulated Lorry", :distance, "/transport/lgv/generic/defra", :type => "rigid", :size => "uk average"),
    :articulated => AmeeCategory.new("Articulated Lorry", :distance, "/transport/lgv/generic/defra", :type => "articulated", :size => "uk average")
  }
  @@per_page = 10
  
  def amee_category
    TYPE[delivery_type.to_sym]
  end
end
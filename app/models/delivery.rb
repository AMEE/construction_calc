class Delivery < ActiveRecord::Base

  belongs_to :project

  include AmeeCarbonStore  
  has_carbon_data_stored_in_amee
  
  # Assumptions on types:
  #   - van - diesel, 1.305-1.740 tonnes
  #   - non-articulated lorry - diesel, fixed load
  #   - articulated lorry - diesel, fixed load
  #   - rail - ?????
  COLOUR = "#FFBA4E"
  TYPE = {
    :van => AmeeCategory.new("Van", :distance, "/transport/van/generic", :fuel => "diesel (by size class)", :size => "1.305 to 1.740 tonnes"),
    :non_articulated => AmeeCategory.new("Non-Articulated Lorry", :distance, "/transport/lgv/generic", :fuel => "diesel", :size => "non articulated"),
    :articulated => AmeeCategory.new("Articulated Lorry", :distance, "/transport/lgv/generic", :fuel => "diesel", :size => "articulated"),
    
    # Not sure if freight train right one to use in AMEE due to GHGP
    # has two variables - which will break stuff
    :rail => AmeeCategory.new("Rail", :distance, "/transport/train/generic/freight/ghgp/other", :type => "train")
  }
  
  def amee_category
    TYPE[delivery_type.to_sym]
  end
end
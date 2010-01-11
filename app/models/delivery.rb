class Delivery < ActiveRecord::Base
  
  include AmeeCarbonStore
  has_carbon_data_stored_in_amee
  
  # Assumptions on types:
  #   - van - diesel, 1.305-1.740 tonnes
  #   - non-articulated lorry - diesel, fixed load
  #   - articulated lorry - diesel, fixed load
  #   - rail - fixed weight (1 tonne) freight train
  COLOUR = "#FFBA4E"
  TRAIN_MASS = 1
  TYPE = {
    :van => AmeeCategory.new("Van", :distance, "/transport/van/generic", :fuel => "diesel (by size class)", :size => "1.305 to 1.740 tonnes"),
    :non_articulated => AmeeCategory.new("Non-Articulated Lorry", :distance, "/transport/lgv/generic", :fuel => "diesel", :size => "non articulated"),
    :articulated => AmeeCategory.new("Articulated Lorry", :distance, "/transport/lgv/generic", :fuel => "diesel", :size => "articulated"),
    :rail => AmeeCategory.new("Rail", :distance, "/transport/train/generic/freight/ghgp/other", :type => "train")
  }
  
  def amee_category
    TYPE[delivery_type.to_sym]
  end
  
  def additional_options
    delivery_type.to_sym == :rail ? {:mass => TRAIN_MASS} : nil
  end
end
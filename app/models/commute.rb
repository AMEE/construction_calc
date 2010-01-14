class Commute < ActiveRecord::Base

  include AmeeCarbonStore
  has_carbon_data_stored_in_amee :type_amount_repeats => true

  # Assumptions on types:
  #   - motorbike - medium, petrol
  #   - car - medium, petrol
  COLOUR = "#86CE66"
  TYPE = {
    :bus => AmeeCategory.new("Bus", :distance, "/transport/bus/generic", :type => "typical"),
    :cycling => AmeeCategory.new("Cycling", :distance, "/transport/other", :type => "cycling"),
    :motorbike => AmeeCategory.new("Motorbike", :distance, "/transport/motorcycle/generic", :fuel => "petrol", :size => "medium"),
    :car => AmeeCategory.new("Car", :distance, "/transport/car/generic", :fuel => "petrol", :size => "medium"),
    :walking => AmeeCategory.new("Walking", :distance, "/transport/other", :type => "walking"),
    :train => AmeeCategory.new("Train", :distance, "/transport/train/generic", :type => "national"),
    :tube => AmeeCategory.new("Tube", :distance, "/transport/train/generic", :type => "underground")
  }
  
  def amee_category
    TYPE[commute_type.to_sym]
  end
end
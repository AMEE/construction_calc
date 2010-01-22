class Commute < ActiveRecord::Base

  include AmeeCarbonStore
  has_carbon_data_stored_in_amee :type_amount_repeats => true

  # Assumptions on types:
  #   - motorbike - medium, petrol
  #   - car - medium, petrol
  COLOUR = "#86CE66"
  TYPE = {
    :bus => AmeeCategory.new("Bus", :journey_distance, "/transport/bus/generic/defra", :type => "typical"),
    :cycling => AmeeCategory.new("Cycling", :distance, "/transport/other", :type => "cycling"),
    :motorbike => AmeeCategory.new("Motorbike", :distance, "/transport/motorcycle/generic/defra", :fuel => "petrol", :size => "medium (125-500cc)"),
    :car => AmeeCategory.new("Car", :distance, "/transport/car/generic/defra/bysize", :fuel => "average", :size => "average"),
    :walking => AmeeCategory.new("Walking", :distance, "/transport/other", :type => "walking"),
    :train => AmeeCategory.new("Train", :journey_distance, "/transport/train/generic/defra", :type => "national"),
    :tube => AmeeCategory.new("Tube", :journey_distance, "/transport/train/generic/defra", :type => "underground")
  }
  
  def amee_category
    TYPE[commute_type.to_sym]
  end
end
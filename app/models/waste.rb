class Waste < ActiveRecord::Base

  belongs_to :project

  include AmeeCarbonStore
  has_carbon_data_stored_in_amee
  
  TYPE = {
    # :cardboard => AmeeCategory.new("Example", :weight, "/transport/bus/generic", :type => "typical"),
    # :carpet_tiles => ,
    # :concrete_and_bricks => ,
    # :general_mixed_waste => ,
    # :metals => ,
    # :plasterboard => ,
    # :plastics => ,
    # :raised_access_floor_tiles => ,
    # :wood => ,
    # :paper => ,
    # :cans_and_plastic_bottles => ,
    # :asbestos => ,
    # :fluorescent_tubes => ,
    # :paint_and_adhesive => ,
    # :refrigerant_gases => ,
    # :septic_tank_waste => ,
    # :glass => 
    
    # TODO waiting to be added to AMEE - actually seems to be in /home/waste
    # TODO needs recycle, dispose option
  }
  
  def amee_category
    TYPE[waste_type.to_sym]
  end
end
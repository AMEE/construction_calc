class Material < ActiveRecord::Base
  
  belongs_to :project

  include AmeeCarbonStore  
  has_carbon_data_stored_in_amee
  
  COLOUR = "#9A5AAB"
  TYPE = {
    :timber => AmeeCategory.new("Timber", :weight, "/embodied/ice", :material => "timber", :type => "general"),
    :carpet => AmeeCategory.new("Carpet", :weight, "/embodied/ice", :material => "carpets", :type => "general"),
    :vinyl => AmeeCategory.new("Vinyl Flooring", :weight, "/embodied/ice", :material => "vinyl flooring", :type => "general vinyl flooring"),
    :plasterboard => AmeeCategory.new("Plasterboard", :weight, "/embodied/ice", :material => "plaster", :type => "plasterboard"),
    :steel => AmeeCategory.new("Steel", :weight, "/embodied/ice", :material => "steel", :type => "general steel", :subtype => "primary"),
    :glass => AmeeCategory.new("Glass", :weight, "/embodied/ice", :material => "glass", :type => "general"),
    :aluminium => AmeeCategory.new("Aluminium", :weight, "/embodied/ice", :material => "aluminium", :type => "general", :subtype => "primary"),
    :insulation => AmeeCategory.new("Insulation", :weight, "/embodied/ice", :material => "insulation", :type => "general"),
    :plastic => AmeeCategory.new("Plastic", :weight, "/embodied/ice", :material => "platics", :type => "general"),
    :concrete => AmeeCategory.new("Concrete", :weight, "/embodied/ice/concrete", :type => "general"),
    :plywood => AmeeCategory.new("Plywood", :weight, "/embodied/ice", :material => "timber", :type => "plywood"),
    :mdf => AmeeCategory.new("MDF", :weight, "/embodied/ice", :material => "timber", :type => "MDF"),
    :particle_board => AmeeCategory.new("Chipboard", :weight, "/embodied/ice", :material => "timber", :type => "particle board"),
    :copper => AmeeCategory.new("Copper", :weight, "/embodied/ice", :material => "copper", :type => "primary"),
    #:ceiling_tiles => ,
    :ceramic_tiles => AmeeCategory.new("Ceramic Tiles", :weight, "/embodied/ice", :material => "ceramics", :type => "tile"),
    :marble_tiles => AmeeCategory.new("Marble Tiles", :weight, "/embodied/ice", :material => "stone", :type => "marble tile")
  }
  
  def amee_category
    TYPE[material_type.to_sym]
  end
end

# steel - general or engineering, then subtype primary or uk typical?
# alumnium - primary or uk typical?
# copper - primary or general (but then have to choose max/min value)

# Is UK typical typical used or produced in UK?
# ceiling tiles - where fit in amee data?
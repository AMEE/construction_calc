class Material < ActiveRecord::Base
  
  TYPE = {
    :timber => AmeeCategory.new("Timber", :weight, "/embodied/ice", :material => "timber", :type => "general"),
    :carpet => AmeeCategory.new("Carpet", :weight, "/embodied/ice", :material => "carpets", :type => "general"),
    :vinyl => AmeeCategory.new("Vinyl Flooring", :weight, "/embodied/ice", :material => "vinyl flooring", :type => "general vinyl flooring"),
    :plasterboard => AmeeCategory.new("Plasterboard", :weight, "/embodied/ice", :material => "plaster", :type => "plasterboard"),
    :steel => AmeeCategory.new("Steel", :weight, "/embodied/ice", :material => "steel", :type => "general steel", :sub_type => "primary"),
    :glass => AmeeCategory.new("Glass", :weight, "/embodied/ice", :material => "glass", :type => "general"),
    :aluminium => AmeeCategory.new("Aluminium", :weight, "/embodied/ice", :material => "aluminium", :type => "general", :sub_type => "primary"),
    :insulation => AmeeCategory.new("Insulation", :weight, "/embodied/ice", :material => "insulation", :type => "general"),
    :plastic => AmeeCategory.new("Plastic", :weight, "/embodied/ice", :material => "platics", :type => "general"),
    :concrete => AmeeCategory.new("Concrete", :weight, "/embodied/ice/concrete", :type => "general"),
    :composite_boards => ,
    :copper => AmeeCategory.new("Copper", :weight, "/embodied/ice", :material => "copper", :type => "primary"),
    :ceiling_tiles => ,
    :ceramic_tiles => AmeeCategory.new("Ceramic Tiles", :weight, "/embodied/ice", :material => "ceramics", :type => "tile")
  }
  
end

# steel - general or engineering, then subtype primary or uk typical?
# alumnium - primary or uk typical?
# copper - primary or general (but then have to choose max/min value)

# Is UK typical typical used or produced in UK?

# composite boards and ceiling tiles - where fit in amee data?
# assume vinyl flooring??
# ceramic tiles very different to stone which is a bit different from marble tiles.  What do they want?
# timber, carpet, glass, steel, aluminium, insulation, plastics, conrete assumed general
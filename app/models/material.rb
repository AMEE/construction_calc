class Material < ActiveRecord::Base

  has_carbon_data_stored_in_amee :profile => :project
  cattr_reader :per_page
  
  COLOUR = "#9A5AAB"
  TYPE = {
    :timber => AmeeCategory.new("Timber", :weight_mass, "/embodied/ice", :material => "timber", :type => "general"),
    :carpet => AmeeCategory.new("Carpet", :weight_mass, "/embodied/ice", :material => "carpets", :type => "general"),
    :vinyl => AmeeCategory.new("Vinyl Flooring", :weight_mass, "/embodied/ice", :material => "vinyl flooring", :type => "general vinyl flooring"),
    :plasterboard => AmeeCategory.new("Plasterboard", :weight_mass, "/embodied/ice", :material => "plaster", :type => "plasterboard"),
    :steel => AmeeCategory.new("Steel", :weight_mass, "/embodied/ice", :material => "steel", :type => "general steel", :subtype => "primary"),
    :glass => AmeeCategory.new("Glass", :weight_mass, "/embodied/ice", :material => "glass", :type => "general"),
    :aluminium => AmeeCategory.new("Aluminium", :weight_mass, "/embodied/ice", :material => "aluminium", :type => "general", :subtype => "primary"),
    :insulation => AmeeCategory.new("Insulation", :weight_mass, "/embodied/ice", :material => "insulation", :type => "general"),
    :plastic => AmeeCategory.new("Plastic", :weight_mass, "/embodied/ice", :material => "plastics", :type => "general"),
    :concrete => AmeeCategory.new("Concrete", :weight_mass, "/embodied/ice/concrete", :type => "general"),
    :plywood => AmeeCategory.new("Plywood", :weight_mass, "/embodied/ice", :material => "timber", :type => "plywood"),
    :mdf => AmeeCategory.new("MDF", :weight_mass, "/embodied/ice", :material => "timber", :type => "MDF"),
    :particle_board => AmeeCategory.new("Chipboard", :weight_mass, "/embodied/ice", :material => "timber", :type => "particle board"),
    :copper => AmeeCategory.new("Copper", :weight_mass, "/embodied/ice", :material => "copper", :type => "primary"),
    :mineral_fibre_ceiling_tiles => AmeeCategory.new("Mineral Fibre Ceiling Tiles", :weight_mass, "/embodied/ice", :material => "insulation", :type => "mineral wool"),
    :metal_ceiling_tiles => AmeeCategory.new("Metal Ceiling Tiles", :weight_mass, "/embodied/ice", :material => "steel", :type => "sheet"),
    :ceramic_tiles => AmeeCategory.new("Ceramic Tiles", :weight_mass, "/embodied/ice", :material => "ceramics", :type => "tile")
  }
  @@per_page = 10
  
  def amee_category
    TYPE[material_type.to_sym]
  end
end
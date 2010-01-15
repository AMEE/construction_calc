class Material < ActiveRecord::Base

  include AmeeCarbonStore
  has_carbon_data_stored_in_amee
  
  # Assumptions on types:
  #   - steel - uk typical makeup of new/recycled
  #   - aluminium - uk typical makeup of new/recycled
  #   - copper - maximum carbon output range
  COLOUR = "#9A5AAB"
  TYPE = {
    :timber => AmeeCategory.new("Timber", :weight, "/embodied/ice", :material => "timber", :type => "general", :unit_conversions => {:kg => [:m3 => 883]}),
    :carpet => AmeeCategory.new("Carpet", :weight, "/embodied/ice", :material => "carpets", :type => "general", :unit_conversions => {:kg => [:m2 => 4.5, :m3 => 500]}),
    :vinyl => AmeeCategory.new("Vinyl Flooring", :weight, "/embodied/ice", :material => "vinyl flooring", :type => "general vinyl flooring", :unit_conversions => {:kg => [:m2 => 4.95, :m3 => 1980]}),
    :plasterboard => AmeeCategory.new("Plasterboard", :weight, "/embodied/ice", :material => "plaster", :type => "plasterboard", :unit_conversions => {:kg => [:m2 => 9, :m3 => 725]}),
    :steel => AmeeCategory.new("Steel", :weight, "/embodied/ice", :material => "steel", :type => "general steel", :subtype => "uk typical", :unit_conversions => {:kg => [:m3 => 7850]}),
    :glass => AmeeCategory.new("Glass", :weight, "/embodied/ice", :material => "glass", :type => "general", :unit_conversions => {:kg => [:m3 => 2579]}),
    :aluminium => AmeeCategory.new("Aluminium", :weight, "/embodied/ice", :material => "aluminium", :type => "general", :subtype => "uk typical", :unit_conversions => {:kg => [:m3 => 2500]}),
    :insulation => AmeeCategory.new("Insulation", :weight, "/embodied/ice", :material => "insulation", :type => "general", :unit_conversions => {:kg => [:m3 => 150]}),
    :plastic => AmeeCategory.new("Plastic", :weight, "/embodied/ice", :material => "platics", :type => "general", :unit_conversions => {:kg => [:m3 => 1]}),
    :concrete => AmeeCategory.new("Concrete", :weight, "/embodied/ice/concrete", :type => "general", , :unit_conversions => {:kg => [:m3 => 2300]}),
    :plywood => AmeeCategory.new("Plywood", :weight, "/embodied/ice", :material => "timber", :type => "plywood", :unit_conversions => {:kg => [:m2 => 6.2, :m3 => 516.5]}),
    :mdf => AmeeCategory.new("MDF", :weight, "/embodied/ice", :material => "timber", :type => "MDF", :unit_conversions => {:kg => [:m2 => 13.32, :m3 => 740]}),
    :particle_board => AmeeCategory.new("Chipboard", :weight, "/embodied/ice", :material => "timber", :type => "particle board", :unit_conversions => {:kg => [:m2 => 11.7, :m3 => 650]}),
    :copper => AmeeCategory.new("Copper", :weight, "/embodied/ice", :material => "copper", :type => "general", :subtype => "maximum value", :unit_conversions => {:kg => [:m3 => 8930]}),
    :mineral_fibre_ceiling_tiles => AmeeCategory.new("Mineral Fibre Ceiling Tiles", :weight, "/embodied/ice", :material => "insulation", :type => "mineral wool", :unit_conversions => {:kg => [:m2 => 3.5, :m3 => 250]}),
    :metal_ceiling_tiles => AmeeCategory.new("Metal Ceiling Tiles", :weight, "/embodied/ice", :material => "steel", :type => "sheet", :unit_conversions => {:kg => [:m2 => 7, :m3 => 212]}),
    :ceramic_tiles => AmeeCategory.new("Ceramic Tiles", :weight, "/embodied/ice", :material => "ceramics", :type => "tile", :unit_conversions => {:kg => [:m2 => 15, :m3 => 1922]}),
    :marble_tiles => AmeeCategory.new("Marble Tiles", :weight, "/embodied/ice", :material => "stone", :type => "marble tile")
  }
  
  def amee_category
    TYPE[material_type.to_sym]
  end
end
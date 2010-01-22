# NOTE.  We use a horrible hack to get raised access floor tiles to work.  This is because it's actually 
# composed of two materials and we need to add/create/update both in amee.
class Material < ActiveRecord::Base

  include AmeeCarbonStore
  has_carbon_data_stored_in_amee
  before_create :add_second_amee_profile_item
  before_update :update_second_amee_profile_item
  after_destroy :delete_second_amee_profile_item
  
  # Assumptions on types:
  #   - steel - primary (virgin) steel
  #   - aluminium - primary (virgin) aluminium
  #   - copper - primary (virgin) copper
  #   - raised access floor tiles - 84% chipboard, 16% steel
  COLOUR = "#9A5AAB"
  TYPE = {
    :timber => AmeeCategory.new("Timber", :weight, "/embodied/ice", :material => "timber", :type => "general", :unit_conversions => {:kg => [:m3 => 883]}),
    :carpet => AmeeCategory.new("Carpet", :weight, "/embodied/ice", :material => "carpets", :type => "general", :unit_conversions => {:kg => [:m2 => 4.5, :m3 => 500]}),
    :vinyl => AmeeCategory.new("Vinyl Flooring", :weight, "/embodied/ice", :material => "vinyl flooring", :type => "general vinyl flooring", :unit_conversions => {:kg => [:m2 => 4.95, :m3 => 1980]}),
    :plasterboard => AmeeCategory.new("Plasterboard", :weight, "/embodied/ice", :material => "plaster", :type => "plasterboard", :unit_conversions => {:kg => [:m2 => 9, :m3 => 725]}),
    :steel => AmeeCategory.new("Steel", :weight, "/embodied/ice", :material => "steel", :type => "general steel", :subtype => "primary", :unit_conversions => {:kg => [:m3 => 7850]}),
    :glass => AmeeCategory.new("Glass", :weight, "/embodied/ice", :material => "glass", :type => "general", :unit_conversions => {:kg => [:m3 => 2579]}),
    :aluminium => AmeeCategory.new("Aluminium", :weight, "/embodied/ice", :material => "aluminium", :type => "general", :subtype => "primary", :unit_conversions => {:kg => [:m3 => 2500]}),
    :insulation => AmeeCategory.new("Insulation", :weight, "/embodied/ice", :material => "insulation", :type => "general", :unit_conversions => {:kg => [:m3 => 150]}),
    :plastic => AmeeCategory.new("Plastic", :weight, "/embodied/ice", :material => "plastics", :type => "general", :unit_conversions => {:kg => [:m3 => 1]}),
    :concrete => AmeeCategory.new("Concrete", :weight, "/embodied/ice/concrete", :type => "general", :unit_conversions => {:kg => [:m3 => 2300]}),
    :plywood => AmeeCategory.new("Plywood", :weight, "/embodied/ice", :material => "timber", :type => "plywood", :unit_conversions => {:kg => [:m2 => 6.2, :m3 => 516.5]}),
    :mdf => AmeeCategory.new("MDF", :weight, "/embodied/ice", :material => "timber", :type => "MDF", :unit_conversions => {:kg => [:m2 => 13.32, :m3 => 740]}),
    :particle_board => AmeeCategory.new("Chipboard", :weight, "/embodied/ice", :material => "timber", :type => "particle board", :unit_conversions => {:kg => [:m2 => 11.7, :m3 => 650]}),
    :copper => AmeeCategory.new("Copper", :weight, "/embodied/ice", :material => "copper", :type => "general", :subtype => "primary", :unit_conversions => {:kg => [:m3 => 8930]}),
    :mineral_fibre_ceiling_tiles => AmeeCategory.new("Mineral Fibre Ceiling Tiles", :weight, "/embodied/ice", :material => "insulation", :type => "mineral wool", :unit_conversions => {:kg => [:m2 => 3.5, :m3 => 250]}),
    :metal_ceiling_tiles => AmeeCategory.new("Metal Ceiling Tiles", :weight, "/embodied/ice", :material => "steel", :type => "sheet", :unit_conversions => {:kg => [:m2 => 7, :m3 => 212]}),
    :ceramic_tiles => AmeeCategory.new("Ceramic Tiles", :weight, "/embodied/ice", :material => "ceramics", :type => "tile", :unit_conversions => {:kg => [:m2 => 15, :m3 => 1922]}),
    :raised_access_floor_tiles => AmeeCategory.new("Raised Access Floor Tiles", :weight, "/embodied/ice", :material => "timber", :type => "particle board", :unit_conversions => {:kg => [:m2 => 36, :m3 => 1152]})
  }
  RAISED_ACCESS_FLOOR_TILES_CHIPBOARD_FRACTION = 0.84
  RAISED_ACCESS_FLOOR_TILES_STEEL_FRACTION = 0.16
  
  def amee_category
    TYPE[material_type.to_sym]
  end
  
  # If it's raised access floor tiles only create the percentage of chipboard that makes up the tiles
  alias_method :get_original_amount, :get_amount
  def get_amount
    raised_access_floor_tiles? ? get_chipboard_amount : get_original_amount
  end
  
  def add_second_amee_profile_item
    return true unless raised_access_floor_tiles?    
    options = {:name => get_name + "_part2", amount_unit_symbol => get_units, :get_item => true,
      amount_symbol => get_steel_amount}
    profile2 = AMEE::Profile::Item.create(amee_profile_category, amee_data_category2_uid, options)
    self.amee_profile_item2_id = profile2.uid
    self.carbon_output_cache += profile2.total_amount
  end
  
  def update_second_amee_profile_item
    return true unless raised_access_floor_tiles?
    result = AMEE::Profile::Item.update(project.amee_connection, amee_profile_item2_path,
      :name => get_name, amount_symbol => get_steel_amount, :get_item => true)
    self.carbon_output_cache += result.total_amount
  end
  
  def delete_second_amee_profile_item
    return true unless raised_access_floor_tiles?
    AMEE::Profile::Item.delete(project.amee_connection, amee_profile_item2_path)
  rescue Exception => e
    logger.error "Unable to remove '#{amee_profile_item2_path}' from AMEE"
  end
  
  alias_method :update_primary_profile_item_carbon_cache, :update_carbon_output_cache
  def update_carbon_output_cache
    if raised_access_floor_tiles?
      update_attributes(:carbon_output_cache => amee_profile_item.total_amount + amee_profile_item2.total_amount)
    else
      update_primary_profile_item_carbon_cache
    end
  end
  
  private
  def raised_access_floor_tiles?
    material_type.to_sym == :raised_access_floor_tiles
  end
  
  def get_steel_amount
    get_original_amount * RAISED_ACCESS_FLOOR_TILES_STEEL_FRACTION
  end
  
  def get_chipboard_amount
    get_original_amount * RAISED_ACCESS_FLOOR_TILES_CHIPBOARD_FRACTION
  end
  
  def amee_data_category2_uid
    AMEE::Data::DrillDown.get(project.amee_connection, TYPE[:steel].drill_down_path).choices.first
  end
  
  def amee_profile_item2
    AMEE::Profile::Item.get(project.amee_connection, amee_profile_item2_path)
  end
  
  def amee_profile_item2_path
    "#{project.profile_path}#{amee_category.path}/#{amee_profile_item2_id}"
  end
end
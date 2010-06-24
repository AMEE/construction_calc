class Waste < ActiveRecord::Base

  has_carbon_data_stored_in_amee :profile => :project, :singular_types => true, :nameless => true
  cattr_reader :per_page

  COLOUR = "#5694ED"
  TYPE = {
    :cardboard => AmeeCategory.new("Cardboard", :weight, "/home/waste/lifecyclewaste", :wasteType => "paper and Card"),
    :paper => AmeeCategory.new("Paper", :weight, "/home/waste/lifecyclewaste", :wasteType => "paper and Card"),
    :carpet_tiles => AmeeCategory.new("Carpet Tiles", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :concrete_and_bricks => AmeeCategory.new("Concrete and Bricks", :weight, "/home/waste/lifecyclewaste", :wasteType => "aggregate materials"),
    :general_mixed_waste => AmeeCategory.new("General Mixed Waste", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :aluminium => AmeeCategory.new("Aluminium", :weight, "/home/waste/lifecyclewaste", :wasteType => "non-ferrous metal"),
    :copper => AmeeCategory.new("Copper", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :steel => AmeeCategory.new("Steel", :weight, "/home/waste/lifecyclewaste", :wasteType => "ferrous metal"),
    :plasterboard => AmeeCategory.new("Plasterboard", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :plastics => AmeeCategory.new("Plastics", :weight, "/home/waste/lifecyclewaste", :wasteType => "plastic (dense)"),
    :raised_access_floor_tiles => AmeeCategory.new("Raised Access Floor Tiles", :weight, "/home/waste/lifecyclewaste", :wasteType => "wood"),
    :wood => AmeeCategory.new("Wood", :weight, "/home/waste/lifecyclewaste", :wasteType => "wood"),
    :cans_plastic_bottles => AmeeCategory.new("Cans & Plastic Bottles", :weight, "/home/waste/lifecyclewaste", :wasteType => "non-ferrous metal"),
    :asbestos => AmeeCategory.new("Asbestos", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :fluorescent_tubes => AmeeCategory.new("Fluorescent Tubes", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :paint_and_adhesive => AmeeCategory.new("Paint and Adhesives", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :refrigerant_gases => AmeeCategory.new("Refrigerant Gases", :weight, "/planet/greenhousegases/gwp", :gas => "HFC-134a"),
    :septic_tank_waste => AmeeCategory.new("Septic Tank Waste", :weight, "/home/waste/lifecyclewaste", :wasteType => "other organic"),
    :glass => AmeeCategory.new("Glass", :weight, "/home/waste/lifecyclewaste", :wasteType => "glass")
  }
  METHOD = {
    :landfill => "quantityLandfill",
    :recycle => "quantityClosedLoop"
  }
  @@per_page = 10
  
  def amee_category
    TYPE[waste_type.to_sym]
  end
  
  def additional_options
    {:disposalEmissionsOnly => true}
  end

  # Hard-code waste amount to zero for recycled waste
  # https://jira.amee.com/browse/MA-233
  def carbon_output_cache
    if waste_method && waste_method.to_sym == :recycle
      0.0
    else
      read_attribute(:carbon_output_cache)
    end
  end
  
  def amount_symbol
    if waste_type.to_sym == :refrigerant_gases
      "emissionRate"
    elsif waste_type.to_sym == :asbestos
      "quantityLandfill"
    else
      METHOD[waste_method.to_sym]
    end
  end
end
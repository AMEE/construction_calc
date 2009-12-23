class Waste < ActiveRecord::Base

  belongs_to :project

  include AmeeCarbonStore
  has_carbon_data_stored_in_amee

  # Assumptions on types:
  #   - carpet tiles -> other waste
  #   - concrete and bricks -> other waste
  #   - plasterboard -> other waste
  #   - raised access floor tiles -> ???
  #   - asbestos -> other waste
  #   - fluorescent tubes -> ???
  #   - paint and adhesive -> ???
  #   - refrigerant gases -> ???
  #   - septic tank waste -> other organic
  COLOUR = "#5694ED"
  TYPE = {
    :cardboard_and_paper => AmeeCategory.new("Cardboard and Paper", :weight, "/home/waste/lifecyclewaste", :wasteType => "paper and Card"),
    :carpet_tiles => AmeeCategory.new("Carpet Tiles", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :concrete_and_bricks => AmeeCategory.new("Concrete and Bricks", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :general_mixed_waste => AmeeCategory.new("General Mixed Waste", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :ferrous_metals => AmeeCategory.new("Ferrous metals", :weight, "/home/waste/lifecyclewaste", :wasteType => "ferrous metal"),
    :non_ferrous_metals => AmeeCategory.new("Non-ferrous metals", :weight, "/home/waste/lifecyclewaste", :wasteType => "non-ferrous metal"),
    :plasterboard => AmeeCategory.new("Plasterboard", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :plastics => AmeeCategory.new("Plastics", :weight, "/home/waste/lifecyclewaste", :wasteType => "plastic (dense)"),
    :raised_access_floor_tiles => AmeeCategory.new("Raised Access Floor Tiles", :weight, "/home/waste/lifecyclewaste", :wasteType => "other waste"),
    :wood => AmeeCategory.new("Wood", :weight, "/home/waste/lifecyclewaste", :wasteType => "wood"),
    :cans => AmeeCategory.new("Cans", :weight, "/home/waste/lifecyclewaste", :wasteType => "non-ferrous metal"),
    :plastic_bottles => AmeeCategory.new("Plastics", :weight, "/home/waste/lifecyclewaste", :wasteType => "plastic (dense)"),
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
  
  def amee_category
    TYPE[waste_type.to_sym]
  end
  
  def amount_symbol
    if waste_type.to_sym == :refrigerant_gases
      "emissionRate"
    else
      METHOD[waste_method.to_sym]
    end
  end
  
  def possible_amount_field_names
    if waste_type.to_sym == :refrigerant_gases
      ["emissionRate"]
    else
      [METHOD[:landfill], METHOD[:recycle]]
    end
  end
end
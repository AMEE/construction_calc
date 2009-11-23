module ApplicationHelper
  def units_name_from_amee_unit(carbon_producing_type)
    Unit.from_amee_unit(carbon_producing_type.units).name
  end
end
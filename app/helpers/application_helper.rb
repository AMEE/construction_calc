module ApplicationHelper
  
  def flash_and_model_messages
    if @show_model_errors
      message_block :on => @show_model_errors
    else
      message_block :on => []
    end
  end
  
  def units_name_from_amee_unit(carbon_producing_type)
    unit_obj = Unit.from_amee_unit(carbon_producing_type.units)
    unit_obj ? unit_obj.name : carbon_producing_type.units
  end
  
  def two_decimal_place_float(amount)
    (amount * 100).round / 100.0
  end
end
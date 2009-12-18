module WasteHelper
  def options_for_waste_type_select
    Waste::TYPE.map {|i| [i[1].name, i[0].to_s]}.sort {|a,b| a[0] <=> b[0]}
  end
  
  def options_for_waste_method_select
    Waste::METHOD.map {|i| [i[0].to_s.capitalize, i[0].to_s]}
  end
  
  def waste_management_carbon_percentage(project)
    return 0.0 if project.total_carbon == 0
    (1000 * project.waste_management_carbon / project.total_carbon).round / 10.0
  end
end
module EnergyConsumptionsHelper
  def options_for_energy_consumption_type_select
    EnergyConsumption::TYPE.map {|i| [i[1].name, i[0].to_s]}.sort {|a,b| a[0] <=> b[0]}
  end
  
  def energy_consumption_carbon_percentage(project)
    return 0.0 if project.total_carbon == 0
    (1000 * project.energy_consumption_carbon / project.total_carbon).round / 10.0
  end
end
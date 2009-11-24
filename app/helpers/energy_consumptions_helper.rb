module EnergyConsumptionsHelper
  def options_for_energy_consumption_type_select
    EnergyConsumption::TYPE.map {|i| [i[1].name, i[0].to_s]}.sort {|a,b| a[0] <=> b[0]}
  end
end
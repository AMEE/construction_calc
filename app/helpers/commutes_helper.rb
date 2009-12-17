module CommutesHelper
  def options_for_commute_type_select
    Commute::TYPE.map {|i| [i[1].name, i[0].to_s]}.sort{|a,b| a[0] <=> b[0]}
  end
  
  def commutes_carbon_percentage(project)
    return 0.0 if project.total_carbon == 0
    (1000 * project.commutes_carbon / project.total_carbon).round / 10.0
  end
end
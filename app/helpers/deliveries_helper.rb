module DeliveriesHelper
  def options_for_delivery_type_select
    Delivery::TYPE.map {|i| [i[1].name, i[0].to_s]}.sort{|a,b| a[0] <=> b[0]}
  end
  
  def delivery_carbon_percentage(project)
    return 0.0 if project.total_carbon == 0
    (1000 * project.deliveries_carbon / project.total_carbon).round / 10.0
  end
end
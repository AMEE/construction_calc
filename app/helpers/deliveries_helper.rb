module DeliveriesHelper
  def options_for_delivery_type_select
    Delivery::TYPE.map {|i| [i[1].name, i[0].to_s]}.sort{|a,b| a[0] <=> b[0]}
  end
end
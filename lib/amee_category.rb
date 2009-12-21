class AmeeCategory
  
  attr_accessor :name, :path
  
  AMEE_ITEM_VALUE_NAMES = {
    :distance => [:distance],
    :weight => [:mass],
    :energy => [:energyConsumption],
    :volumable_energy => [:volumePerTime, :energyConsumption]
  }

  AMEE_ITEM_VALUE_UNITS = {
    :distance => [Unit.km, Unit.miles],
    :mass => [Unit.kg, Unit.tonnes],
    :energyConsumption => [Unit.kwh],
    :volumePerTime => [Unit.litres]#, Unit.uk_gallons] 
  }
  
  def initialize(name, type, profile_category_path, path_options = {}, *args)
    @name = name
    @type = type
    @path = profile_category_path
    @path_options = path_options
  end
  
  def drill_down_path
    "/data#{@path}/drill?#{@path_options.to_query}"
  end
  
  def unit_options
    item_value_units.map{|unit| [unit.name, unit.amee_api_unit]}
  end
  
  def item_value_names
    AMEE_ITEM_VALUE_NAMES[@type]
  end
  
  def item_value_name(amee_unit)
    item_value_names.each do |name|
      return name if amee_api_units(name).include?(amee_unit)
    end
    return nil
  end
  
  private
  def item_value_units
    item_value_names.map{|t| AMEE_ITEM_VALUE_UNITS[t]}.flatten
  end
  
  def amee_api_units(name)
    AMEE_ITEM_VALUE_UNITS[name].map{|u| u.amee_api_unit}
  end
end
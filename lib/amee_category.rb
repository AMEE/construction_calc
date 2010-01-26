# Handles alternative units that come in the format: 
#   {:kg => [:m3 => 2.5, :abc => 0.3], :xyz => [:efg => 0.6]}
# In this example we get weight from volume by doing m3 * 2.5
class AmeeCategory
  
  attr_accessor :name, :path
  
  AMEE_ITEM_VALUE_NAMES = {
    :distance => [:distance],
    :journey_distance => [:distancePerJourney],
    :weight => [:mass],
    :energy => [:energyConsumption],
    :volumable_energy => [:volumePerTime, :energyConsumption]
  }

  AMEE_ITEM_VALUE_UNITS = {
    :distance => [Unit.km, Unit.miles],
    :distancePerJourney => [Unit.km, Unit.miles],
    :mass => [Unit.kg, Unit.tonnes],
    :energyConsumption => [Unit.kwh],
    :volumePerTime => [Unit.litres],
  }
  
  def initialize(name, type, profile_category_path, options = {}, *args)
    @name = name
    @type = type
    @path = profile_category_path
    @conversions = options.delete(:unit_conversions)
    @path_options = options
  end
  
  def drill_down_path
    "/data#{@path}/drill?#{@path_options.to_query}"
  end
  
  def unit_options
    unit_options = item_value_units.map{|unit| [unit.name, unit.amee_api_unit]}
    unit_options += alternative_unit_options if has_alternative_units?
    unit_options
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
  
  def has_alternative_units?
    !@conversions.nil?
  end
  
  def has_alternative_unit?(unit)
    return false unless has_alternative_units?    
    units = @conversions.values.map(&:first).map(&:keys).flatten
    units.include?(unit.to_sym)
  end
  
  def alternative_unit_converts_to(unit_name)
    units_to_alternates = merge_hashes(@conversions.map {|k,v| {k => v.first.keys}})
    units_to_alternates.each do |amee_unit, alt_units|
      return amee_unit if alt_units.include?(unit_name.to_sym)
    end
    return nil
  end
  
  def alternative_unit_conversion_factor(unit_name)
    alternative_units_to_conversions.each do |alt_unit, conversion|
      return conversion if alt_unit == unit_name.to_sym
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
  
  def alternative_units_to_conversions
    merge_hashes(@conversions.map {|k,v| v.first})
  end
  
  def alternative_unit_options
    alternative_units_to_conversions.keys.map {|unit| [unit.to_s, unit.to_s]}
  end
  
  # Does [{:a => 1, :b => 2}, {:c => 3}, {:d => 4}]  to  {:a => 1, :b => 2, :c => 3, :d => 4}
  def merge_hashes(array_of_hashes)
    result = {}
    array_of_hashes.each do |item|
      item.keys.each do |k|
        result[k] = item[k]
      end
    end
    result
  end
end
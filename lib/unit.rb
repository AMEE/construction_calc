class Unit

  NAME = {
    :km => "km",
    :miles => "miles",
    :kg => "kg",
    :tonnes => "tonnes",
    :kwh => "kWh",
    :litres => "litres",
    :uk_gallons => "UK Gallons"
  }

  AMEE_API_UNITS = {
    :km => "km",
    :miles => "mi",
    :kg => "kg",
    :tonnes => "t",
    :kwh => "kWh",
    :litres => "L",
    :uk_gallons => "gal_uk"
  }
  
  def initialize(type, *args)
    @type = type
  end
  
  def self.from_amee_unit(unit)
    AMEE_API_UNITS.each do |key, value|
      return new(key) if value == unit
    end
    return nil
  end
  
  def name
    NAME[@type]
  end
  
  def amee_api_unit
    AMEE_API_UNITS[@type]
  end
  
  def self.km
    new(:km)
  end
  
  def self.miles
    new(:miles)
  end
  
  def self.kg
    new(:kg)
  end
  
  def self.tonnes
    new(:tonnes)
  end
  
  def self.kwh
    new(:kwh)
  end
  
  def self.litres
    new(:litres)
  end
  
  def self.uk_gallons
    new(:uk_gallons)
  end
end
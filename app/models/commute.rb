class Commute < ActiveRecord::Base

  TYPE = {
    :bus => AmeeCategory.new("Bus", :distance, "/transport/bus/generic", :type => "typical"),
    :cycling => AmeeCategory.new("Cycling", :distance, "/transport/other", :type => "cycling"),
    :motorbike => AmeeCategory.new("Motorbike", :distance, "/transport/motorcycle/generic", :fuel => "petrol", :size => "medium"),
    :car => AmeeCategory.new("Car", :distance, "/transport/car/generic", :fuel => "petrol", :size => "medium"),
    :walking => AmeeCategory.new("Walking", :distance, "/transport/other", :type => "walking"),
    :train => AmeeCategory.new("Train", :distance, "/transport/train/generic", :type => "national"),
    :tube => AmeeCategory.new("Tube", :distance, "/transport/train/generic", :type => "underground")
  }
  
  attr_accessor :amount, :units
  
  validates_uniqueness_of :name
  # TODO validate allowed characters for name subject to AMEE restrictions
  
  belongs_to :project
  
  before_save :update_amee
  
  def commute_type_profile_path
    commute_type_category.path
  end
  # TODO rename to be generic
  def commute_type_drill_down_path
    commute_type_category.drill_down_path
  end
  
  def amount
    if amee_profile_item_id.nil?
      @amount
    else
      amee_profile_item_field(possible_amount_field_names).first
    end
  end
  
  def units
    if amee_profile_item_id.nil?
      @units
    else
      amee_profile_item_field(possible_amount_field_names).last
    end
  end
  
  protected
  def update_amee
    category = AMEE::Profile::Category.get(project.amee_connection, 
      "#{project.profile_path}#{commute_type_profile_path}")
    category_id = AMEE::Data::DrillDown.get(project.amee_connection, commute_type_drill_down_path).choices.first
    # TODO could be > 1 choice?  
    # TODO How know getting right ID for generic bus?  Should be BF374F8256CA but can't see that in web UI or JSON

    profile = AMEE::Profile::Item.create(category, category_id, 
      amount_symbol => self.amount, amount_unit_symbol => self.units)
    # TODO ring accountant (dividend + ni implicatons - pension and health) and olga
    # TODO hard coding of commute in this class
    #      hard coding of :bus for unit options in new.html.erb / also need to prepopulate page with options for units for each type

    self.amee_profile_item_id = profile.uid
    
    return true
  end
  
  def amount_symbol
    commute_type_category.item_value_name(self.units)
  end
  
  def amount_unit_symbol
    commute_type_category.item_value_unit_name(self.units)
  end
  
  # TODO amee_profile_item_field cache result as call twice and does API call
  # TODO get into git and svn repos
  # TODO Need api link up for destroy
  # TODO move name field to AMEE or do want copy in local DB too?  If move to AMEE might be an idea to prefix with client name (in which case will need dynamic validation for length)
  # TODO pull out common code into module
  # TODO add amee fields and validations
  # TODO distance integer or float?
  
  private
  def possible_amount_field_names
    commute_type_category.item_value_names
  end
  
  # TODO rename to be generic
  def commute_type_category
    TYPE[commute_type.to_sym]
  end
  
  def amee_profile_item_field(possible_field_names)
    amee_profile_item.values.each do |value|
      return [value[:value], value[:unit]] if possible_field_names.map{|f| f.to_s}.include?(value[:path])
    end
    return nil
  end

  def amee_profile_item
    AMEE::Profile::Item.get(project.amee_connection, amee_profile_item_path)
  end
  
  def amee_profile_item_path
    "#{project.profile_path}#{commute_type_profile_path}/#{amee_profile_item_id}"
  end
end
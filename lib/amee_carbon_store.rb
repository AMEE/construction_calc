module AmeeCarbonStore
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_carbon_data_stored_in_amee
      attr_writer :amount, :units
  
      include AmeeCarbonStore::InstanceMethods

      # TODO add amee fields and validations, distance integer or float?
      validates_uniqueness_of :name
      # TODO validate allowed characters for name subject to AMEE restrictions
  
      before_create :add_to_amee
      before_update :update_amee
      after_destroy :delete_from_amee
    end
  end

  # TODO move name field to AMEE or do want copy in local DB too?  If move to AMEE might be an idea to prefix with client name (in which case will need dynamic validation for length)

  module InstanceMethods
    def amount
      if new_record?
        @amount
      else
        @amount || amee_profile_item_field(possible_amount_field_names).first
      end
    end

    def units
      if new_record?
        @units
      else
        @units || amee_profile_item_field(possible_amount_field_names).last
      end
    end

    # protected
    def amount_symbol
      amee_category.item_value_name(self.units)
    end

    def amount_unit_symbol
      amee_category.item_value_unit_name(self.units)
    end

    # private
    # Returns an AmeeCategory for the model instance
    def amee_category
      raise "Must be implemented in model"
    end

    def possible_amount_field_names
      amee_category.item_value_names
    end

    def amee_profile_item_field(possible_field_names)
      potential_fields = potential_amee_profile_fields(possible_field_names)
      if potential_fields.size == 0
        return nil
      elsif potential_fields.size == 1
        return [potential_fields.first[:value], potential_fields.first[:unit]]
      else
        potential_fields.each do |field|
          return [field[:value], field[:unit]] if field[:value].to_i != 0 # assumes number though :(
        end
      end
    end
    # TODO clean these two up, is number assumption bad - think so
    def potential_amee_profile_fields(possible_field_names)
      matches = []
      amee_profile_item.values.each do |value|
        matches << value if possible_field_names.map{|f| f.to_s}.include?(value[:path])
      end
      matches
    end

    def amee_profile_item
      @amee_profile_item_cache ||= AMEE::Profile::Item.get(project.amee_connection, amee_profile_item_path)
    end

    def amee_profile_item_path
      "#{project.profile_path}#{amee_category.path}/#{amee_profile_item_id}"
    end

    def add_to_amee
      category = AMEE::Profile::Category.get(project.amee_connection, 
        "#{project.profile_path}#{amee_category.path}")
      category_id = AMEE::Data::DrillDown.get(project.amee_connection, amee_category.drill_down_path).choices.first
      # TODO could be > 1 choice?  
      # TODO How know getting right ID for generic bus?  Should be BF374F8256CA but can't see that in web UI or JSON

      profile = AMEE::Profile::Item.create(category, category_id, 
        amount_symbol => self.amount, amount_unit_symbol => self.units, :get_item => true)

      self.amee_profile_item_id = profile.uid
      self.carbon_output_cache = profile.total_amount

      return true
    end

    # TODO if have name change need to update here
    def update_amee
      result = AMEE::Profile::Item.update(project.amee_connection, amee_profile_item_path, 
        amount_symbol => self.amount, :get_item => true)
      self.carbon_output_cache = result.total_amount
    end

    def delete_from_amee
      AMEE::Profile::Item.delete(project.amee_connection, amee_profile_item_path)
    rescue Exception => e
      logger.error "Unable to remove '#{amee_profile_item_path}' from AMEE"
    end
  end
end
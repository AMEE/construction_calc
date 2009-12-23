module AmeeCarbonStore
  def self.included(base)
    base.extend ClassMethods
    
    base.module_eval do 
      @@per_page = 10
    end
  end

  module ClassMethods
    def has_carbon_data_stored_in_amee
      attr_writer :amount, :units
      cattr_reader :per_page

      validates_uniqueness_of :name, :scope => :project_id
      validates_format_of :name, :with => /\A[\w -]+\Z/, :message => "must be letters, numbers or underscores only"
      validates_length_of :name, :maximum => 250
      validates_numericality_of :amount
      validate_on_create :units_are_valid
  
      before_create :add_to_amee
      before_update :update_amee
      after_destroy :delete_from_amee
      
      include AmeeCarbonStore::InstanceMethods
    end
    
    def update_carbon_caches
      find(:all).each do |item|
        item.update_carbon_output_cache
      end.size
    end
  end

  module InstanceMethods
    def amount
      if new_record?
        @amount
      else
        @amount || amee_profile_item_field[:amount]
      end
    end

    def units
      if new_record?
        @units
      else
        @units || amee_profile_item_field[:unit]
      end
    end
    
    def update_carbon_output_cache
      update_attributes(:carbon_output_cache => amee_profile_item.total_amount)
    end

    protected
    # Should return an AmeeCategory the model instance is associated with
    def amee_category
      raise "Must be implemented in model"
    end
    
    # Override in model to pass additional options on create
    def additional_options
      nil
    end
    
    # Override this if the amount symbol isn't inferable from the units
    def amount_symbol
      amee_category.item_value_name(self.units)
    end

    def amount_unit_symbol
      (amount_symbol.to_s + "Unit").to_sym
    end

    private
    # This lets us reuse the AR validations
    def amount_before_type_cast
      self.amount
    end
    
    def units_are_valid
      errors.add("units", "are not valid") if amee_category.item_value_name(self.units).nil?
    end
    
    def amee_profile_item_field
      potential_fields = potential_amee_profile_fields
      if potential_fields.size == 0
        return nil
      elsif potential_fields.size == 1
        return {:amount => potential_fields.first[:value], :unit => potential_fields.first[:unit]}
      else
        # Assumes the field we're looking for is a number
        potential_fields.each do |field|
          return {:amount => field[:value], :unit => field[:unit]} if field[:value].to_i != 0
        end
      end
    end

    def potential_amee_profile_fields
      matches = []
      amee_profile_item.values.each do |value|
        matches << value if possible_amount_field_names.map{|f| f.to_s}.include?(value[:path])
      end
      matches
    end

    # override if not inferable from units
    def possible_amount_field_names
      amee_category.item_value_names
    end

    def amee_profile_item
      @amee_profile_item_cache ||= AMEE::Profile::Item.get(project.amee_connection, 
        amee_profile_item_path)
    end

    def amee_profile_item_path
      "#{project.profile_path}#{amee_category.path}/#{amee_profile_item_id}"
    end

    def add_to_amee
      profile = create_amee_profile
      self.amee_profile_item_id = profile.uid
      self.carbon_output_cache = profile.total_amount
      return true
    end

    def create_amee_profile
      category = AMEE::Profile::Category.get(project.amee_connection, 
        "#{project.profile_path}#{amee_category.path}")
      options = {:name => self.name, amount_symbol => self.amount,
        amount_unit_symbol => self.units, :get_item => true}
      options.merge!(additional_options) if additional_options
      AMEE::Profile::Item.create(category, amee_data_category_uid, options)
    end

    def amee_data_category_uid
      Rails.cache.fetch("#{DRILLDOWN_CACHE_PREFIX}_#{amee_category.drill_down_path.gsub(/[^\w]/, '')}") do
        AMEE::Data::DrillDown.get(project.amee_connection, amee_category.drill_down_path).choices.first
      end
    end

    def update_amee
      result = AMEE::Profile::Item.update(project.amee_connection, amee_profile_item_path, 
        :name => self.name, amount_symbol => self.amount, :get_item => true)
      self.carbon_output_cache = result.total_amount
      return true
    end

    def delete_from_amee
      AMEE::Profile::Item.delete(project.amee_connection, amee_profile_item_path)
    rescue Exception => e
      logger.error "Unable to remove '#{amee_profile_item_path}' from AMEE"
    end
  end
end
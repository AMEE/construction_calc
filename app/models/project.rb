class Project < ActiveRecord::Base
  
  belongs_to :client
  has_many :roles, :as => :allowable
  has_many :commutes
  
  # TODO
  has_many :deliveries
  has_many :materials
  
  # TODO rename - models called Energy and Waste
  has_many :energy_consumptions
  has_many :waste_management
  
  has_amee_profile
  
  def profile_path
    "/profiles/#{amee_profile}"
  end
  
  def total_carbon
    # TODO improve + add all types
    # NOTE - only total per page or is it with profile categories?
    total = 0
    Commute::TYPE.each do |key, commute_type|
      # DRY this up a bit
      total += AMEE::Profile::Category.get(amee_connection, "#{profile_path}#{commute_type.path}").total_amount
    end
    total
  end
  
  # TODO on create add /metadata to profile with UK country (even though default)
end
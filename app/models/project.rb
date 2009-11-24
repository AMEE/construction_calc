class Project < ActiveRecord::Base
  
  belongs_to :client
  #has_many :roles, :as => :allowable  # need this?
  has_many :commutes
  has_many :energy_consumptions
  
  # TODO
  has_many :deliveries
  has_many :materials
  
  # TODO rename model
  has_many :waste_management
  
  has_amee_profile
  
  def profile_path
    "/profiles/#{amee_profile}"
  end
  
  def total_carbon    
    # Had to cache carbon data for each item and purge at weekend when plenty of time
    # Can't cache by category as transport spans multiple classes = major fail
    # Other factors paging through results and manual ask for carbon value each time update or delete
    
    # TODO all types, also anything added here should be updated in the cronjob
    (commutes + energy_consumptions).map {|i| i.carbon_output_cache}.sum
  end
  
  # TODO on create add /metadata to profile with UK country (even though default)
end
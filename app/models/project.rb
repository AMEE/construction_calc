class Project < ActiveRecord::Base
  
  belongs_to :client
  #has_many :roles, :as => :allowable  # need this?
  has_many :commutes
  has_many :deliveries
  has_many :materials
  has_many :energy_consumptions
  has_many :wastes
  
  has_amee_profile
  
  def profile_path
    "/profiles/#{amee_profile}"
  end
  
  # TODO there are other things this needs to have such as floor area, manager, start date (is in DB or actual project start?)
  #      all need validations etc
  
  def total_carbon
    types = commutes + deliveries + materials + energy_consumptions + wastes
    types.map {|i| i.carbon_output_cache}.sum
  end
  
  # TODO on create add /metadata to profile with UK country (even though default)
end
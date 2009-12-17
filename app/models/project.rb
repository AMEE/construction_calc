class Project < ActiveRecord::Base
  
  validates_uniqueness_of :name, :scope => :client_id
  validates_numericality_of :floor_area
  
  belongs_to :client
  has_many :roles, :as => :allowable, :dependent => :destroy
  has_many :commutes
  has_many :deliveries
  has_many :materials
  has_many :energy_consumptions
  has_many :wastes
  
  has_amee_profile
  
  def profile_path
    "/profiles/#{amee_profile}"
  end
  
  def total_carbon
    types = commutes + deliveries + materials + energy_consumptions + wastes
    types.map {|i| i.carbon_output_cache}.sum
  end
end
class Project < ActiveRecord::Base
  
  validates_uniqueness_of :name, :scope => :client_id
  validates_numericality_of :floor_area
  validates_numericality_of :value
  
  belongs_to :client
  has_many :roles, :as => :allowable, :dependent => :destroy
  has_many :commutes
  has_many :deliveries
  has_many :materials
  has_many :energy_consumptions
  has_many :wastes
  
  before_create :check_client_project_limit
  
  has_amee_profile
  
  DATE_FORMAT = "%d/%m/%Y"
  GOOGLE_CHART_BASE_URL = "http://chart.apis.google.com/chart"
  
  def profile_path
    "/profiles/#{amee_profile}"
  end
  
  def commutes_carbon
    commutes.map{|c| c.carbon_output_cache}.sum
  end
  
  def deliveries_carbon
    deliveries.map{|d| d.carbon_output_cache}.sum
  end
  
  def materials_carbon
    materials.map{|m| m.carbon_output_cache}.sum
  end
  
  def energy_consumption_carbon
    energy_consumptions.map{|e| e.carbon_output_cache}.sum
  end
  
  def waste_management_carbon
    wastes.map{|w| w.carbon_output_cache}.sum
  end
  
  def total_carbon
    commutes_carbon + deliveries_carbon + materials_carbon + energy_consumption_carbon + waste_management_carbon
  end
  
  def start_date
    date = read_attribute(:start_date) || Date.today
    date.strftime(DATE_FORMAT)
  end
  
  def start_date=(date_string)
    write_attribute(:start_date, Date.strptime(date_string, DATE_FORMAT))
  end
  
  def google_chart_url
    "#{GOOGLE_CHART_BASE_URL}?#{google_chart_options.collect{|k,v| "#{k}=#{URI.escape(v)}"}.join("&")}"
  end
  
  private
  def type_percents
    percents = []
    [commutes, deliveries, materials, energy_consumptions, wastes].each do |type|
      percents << (100 * type.map {|i| i.carbon_output_cache}.sum) / total_carbon.to_f
    end
    percents
  end
  
  def check_client_project_limit
    if client.projects.size >= Client::PROJECT_LIMIT
      errors.add_to_base "You are limited to #{Client::PROJECT_LIMIT} projects"
      return false
    end
  end
  
  def google_chart_options
    classes = [Commute, Delivery, Material, EnergyConsumption, Waste]
    {:cht => "p3",
     :chd => "t:#{type_percents.join(',')}&chl=#{classes.map{|c| c.to_s.underscore.humanize}.join('|')}",
     :chs => "530x200", :chco => "#{classes.map {|c| c::COLOUR[1,6]}.join(',')}"}
  end
end
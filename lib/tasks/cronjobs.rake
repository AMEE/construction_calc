namespace :cronjobs do
  
  # This application caches carbon values from AMEE.  As the algorithms behind amee can change at any point,
  # the carbon values should be updated at a regular interval.  We recommend a call frequency of weekly.
  # Depending on the amount of data this cronjob can take a little while so it's recommended to be run at a
  # time when the site is not so busy.
  desc "Update the cached carbon output values"
  task :update_carbon_cache => :environment do
    Commute.update_carbon_caches
    EnergyConsumption.update_carbon_caches
  end
end
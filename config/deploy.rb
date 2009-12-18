set :stages, %w(development staging production)
set :default_stage, "development"
require "capistrano/ext/multistage"

# This will be the name of the top-level directory under /var/www/apps
set :application, "overbury"

# If you aren't deploying to /var/www/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"

# Deployment Tasks
namespace :deploy do
  
  task :default do
    migrations
    cleanup
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    # amee.yml
    run "rm -rf  #{current_path}/config/amee.yml"
    run "ln -nfs #{shared_path}/config/amee.yml #{release_path}/config/amee.yml"
    # database.yml
    run "rm -rf  #{current_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    # settings.yml
    run "rm -rf  #{current_path}/config/settings.yml"
    run "ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'
#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :rails_env, "staging"
set :rake_path, "rake"

#############################################################
#	Servers
#############################################################

set :user, "rails"
set :domain, "blizzard.amee.com"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :subversion
set :svn_user, ENV['amee_svn_user'] || Proc.new { Capistrano::CLI.password_prompt('SVN User: ') }
set :svn_password, ENV['amee_svn_pass'] || Proc.new { Capistrano::CLI.password_prompt('SVN Password: ') }
set :repository, Proc.new { "--username #{svn_user} " +
                            "--password #{svn_password} " +
                            "--no-auth-cache " +
                            "http://svn.amee.com/internal/projects/overbury" }

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
end
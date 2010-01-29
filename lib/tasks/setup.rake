namespace :setup do

  # Performs application setup
  desc "Sets up initial application data - only run once. Run as rake setup:data <username> <email> <name> <password> <clientname>"
  task :data => :environment do
    # Get commandline options
    user_opts = {
      :login => ARGV[1],
      :email => ARGV[2],
      :name => ARGV[3],
      :password => ARGV[4],
      :password_confirmation => ARGV[4],
    }
    client_opts = {
      :name => ARGV[5]
    }
    # Create user
    User.create(user_opts)
    User.first.register!
    User.first.activate!
    User.first.roles << Role.create(:role_type => Role::Type::SUPER_ADMIN)
    # Create client
    Client.create(client_opts)
  end
end
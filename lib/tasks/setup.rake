namespace :setup do

  # Performs application setup
  desc 'Sets up initial application data - only run once. Run as: rake "setup:data[<username>, <email>, <name>, <password>, <clientname>]"'
  task :data, :login, :email, :name, :password, :clientname, :needs => :environment do |t, args|
    # Get commandline options
    user_opts = {
      :login => args[:login],
      :email => args[:email],
      :name => args[:name],
      :password => args[:password],
      :password_confirmation => args[:password],
    }
    client_opts = {
      :name => args[:clientname]
    }
    # Create user
    User.create!(user_opts)
    User.first.register!
    User.first.activate!
    User.first.roles << Role.create(:role_type => Role::Type::SUPER_ADMIN)
    # Create client
    Client.create(client_opts)
  end
end
